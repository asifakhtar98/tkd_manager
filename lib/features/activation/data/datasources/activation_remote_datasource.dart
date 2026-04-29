import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/app_config.dart';
import 'package:tkd_saas/core/shared/data/models/activation_request_model.dart';
import '../models/user_activation_model.dart';

/// Contract for all Supabase activation-related remote calls.
abstract class ActivationRemoteDataSource {
  /// Inserts a new activation request for the currently authenticated user.
  Future<ActivationRequestModel> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  });

  /// Fetches the `user_activations` row for the current user, or `null`.
  Future<UserActivationModel?> fetchCurrentUserActivation();

  /// Checks if the current user has any activation_requests with `status = 'pending'`.
  Future<bool> hasCurrentUserPendingActivationRequest();

  /// Returns `true` if the current user exists in the `admin_users` table.
  Future<bool> isCurrentUserAdmin();

  /// Sends the post-approval email to the user if a recipient email is available.
  Future<void> sendActivationApprovedEmail({
    required ActivationRequestModel activationRequestModel,
    required DateTime approvedAt,
    required DateTime expiresAt,
  });
}

@LazySingleton(as: ActivationRemoteDataSource)
class ActivationRemoteDataSourceImpl implements ActivationRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final Dio _dio = Dio();

  ActivationRemoteDataSourceImpl(this._supabaseClient);

  String get _currentUserId => _supabaseClient.auth.currentUser!.id;

  @override
  Future<ActivationRequestModel> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  }) async {
    final String? currentUserEmail = _supabaseClient.auth.currentUser?.email;
    final Map<String, dynamic> billingInfo = <String, dynamic>{
      if (currentUserEmail != null && currentUserEmail.trim().isNotEmpty)
        'email': currentUserEmail.trim(),
    };

    final response = await _supabaseClient
        .from('activation_requests')
        .insert({
          'user_id': _currentUserId,
          'contact_name': contactName,
          'requested_days': requestedDays,
          'total_amount': totalAmount,
          'status': 'pending',
          'billing_info': billingInfo,
        })
        .select()
        .single();

    final activationRequestModel = ActivationRequestModel.fromJson(response);
    unawaited(
      _sendActivationRequestNotificationEmails(
        activationRequestModel: activationRequestModel,
      ),
    );
    return activationRequestModel;
  }

  @override
  Future<UserActivationModel?> fetchCurrentUserActivation() async {
    final response = await _supabaseClient
        .from('user_activations')
        .select()
        .eq('user_id', _currentUserId)
        .maybeSingle();

    if (response == null) return null;
    return UserActivationModel.fromJson(response);
  }

  @override
  Future<bool> hasCurrentUserPendingActivationRequest() async {
    final response = await _supabaseClient
        .from('activation_requests')
        .select('id')
        .eq('user_id', _currentUserId)
        .eq('status', 'pending')
        .limit(1);

    return (response as List).isNotEmpty;
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    final response = await _supabaseClient
        .from('admin_users')
        .select('user_id')
        .eq('user_id', _currentUserId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<void> sendActivationApprovedEmail({
    required ActivationRequestModel activationRequestModel,
    required DateTime approvedAt,
    required DateTime expiresAt,
  }) async {
    final String? approvalRecipientEmail = _extractBillingEmail(
      activationRequestModel.billingInfo,
    );

    if (approvalRecipientEmail == null) {
      debugPrint(
        'Skipping activation approval email because billing_info.email is missing for request ${activationRequestModel.id}.',
      );
      return;
    }

    try {
      await _sendResendEmail(
        to: approvalRecipientEmail,
        subject: 'Your software activation is approved',
        html: _buildActivationApprovedHtml(
          activationRequestModel: activationRequestModel,
          approvedAt: approvedAt,
          expiresAt: expiresAt,
          approvalRecipientEmail: approvalRecipientEmail,
        ),
      );
    } catch (error) {
      _logEmailDeliveryFailure(
        emailKindLabel: 'activation approval',
        error: error,
      );
    }
  }

  Future<void> _sendActivationRequestNotificationEmails({
    required ActivationRequestModel activationRequestModel,
  }) async {
    final String? currentUserEmail = _extractBillingEmail(
      activationRequestModel.billingInfo,
    );

    await _sendOwnerNotificationEmail(
      activationRequestModel: activationRequestModel,
      currentUserEmail: currentUserEmail,
    );

    if (currentUserEmail == null || currentUserEmail.trim().isEmpty) {
      debugPrint(
        'Skipping activation confirmation email because the current user has no email address.',
      );
      return;
    }

    await _sendUserConfirmationEmail(
      activationRequestModel: activationRequestModel,
      currentUserEmail: currentUserEmail,
    );
  }

  Future<void> _sendOwnerNotificationEmail({
    required ActivationRequestModel activationRequestModel,
    required String? currentUserEmail,
  }) async {
    try {
      await _sendResendEmail(
        to: AppConfig.productOwnerEmail,
        subject:
            'New activation request from ${_escapeHtml(activationRequestModel.contactName)}',
        html: _buildOwnerNotificationHtml(
          activationRequestModel: activationRequestModel,
          currentUserEmail: currentUserEmail,
        ),
      );
    } catch (error) {
      _logEmailDeliveryFailure(
        emailKindLabel: 'owner activation',
        error: error,
      );
    }
  }

  Future<void> _sendUserConfirmationEmail({
    required ActivationRequestModel activationRequestModel,
    required String currentUserEmail,
  }) async {
    try {
      await _sendResendEmail(
        to: currentUserEmail,
        subject: 'Activation request received',
        html: _buildUserConfirmationHtml(
          activationRequestModel: activationRequestModel,
          currentUserEmail: currentUserEmail,
        ),
      );
    } catch (error) {
      _logEmailDeliveryFailure(
        emailKindLabel: 'user activation confirmation',
        error: error,
      );
    }
  }

  Future<void> _sendResendEmail({
    required String to,
    required String subject,
    required String html,
  }) async {
    await _dio.post(
      '${AppConfig.externalServerBaseUrl}/api/v1/send-external-smtp-email',
      data: {
        'external_smtp_key': AppConfig.resendApiKey,
        'to': to,
        'subject': subject,
        'html': html,
      },
      options: Options(
        responseType: ResponseType.plain,
        headers: {
          'x-user-agent-id': AppConfig.whatsevrUserAgentId,
          'x-user-agent-name': AppConfig.whatsevrUserAgentName,
          'x-user-agent-type': AppConfig.whatsevrUserAgentType,
          'x-app-version-code': AppConfig.whatsevrAppVersionCode,
          'Authorization': AppConfig.whatsevrBearerToken,
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  String _buildOwnerNotificationHtml({
    required ActivationRequestModel activationRequestModel,
    required String? currentUserEmail,
  }) {
    final String contactName = _escapeHtml(activationRequestModel.contactName);
    final String requestId = _escapeHtml(activationRequestModel.id);
    final String userEmail = _escapeHtml(currentUserEmail ?? 'Not available');
    final String createdAt = _escapeHtml(
      _formatTimestamp(activationRequestModel.createdAt),
    );

    return '''
<p>A new activation request has been submitted.</p>
<p><strong>Contact name:</strong> $contactName</p>
<p><strong>User email:</strong> $userEmail</p>
<p><strong>Requested days:</strong> ${activationRequestModel.requestedDays}</p>
<p><strong>Total amount:</strong> Rs ${activationRequestModel.totalAmount}</p>
<p><strong>Request ID:</strong> $requestId</p>
<p><strong>Created at:</strong> $createdAt</p>
''';
  }

  String _buildUserConfirmationHtml({
    required ActivationRequestModel activationRequestModel,
    required String currentUserEmail,
  }) {
    final String contactName = _escapeHtml(activationRequestModel.contactName);
    final String requestId = _escapeHtml(activationRequestModel.id);
    final String userEmail = _escapeHtml(currentUserEmail);
    final String createdAt = _escapeHtml(
      _formatTimestamp(activationRequestModel.createdAt),
    );

    return '''
<p>Your activation request has been received successfully.</p>
<p>Our team will review your payment and activate your software after verification.</p>
<p><strong>Contact name:</strong> $contactName</p>
<p><strong>User email:</strong> $userEmail</p>
<p><strong>Requested days:</strong> ${activationRequestModel.requestedDays}</p>
<p><strong>Total amount:</strong> Rs ${activationRequestModel.totalAmount}</p>
<p><strong>Request ID:</strong> $requestId</p>
<p><strong>Submitted at:</strong> $createdAt</p>
''';
  }

  String _buildActivationApprovedHtml({
    required ActivationRequestModel activationRequestModel,
    required DateTime approvedAt,
    required DateTime expiresAt,
    required String approvalRecipientEmail,
  }) {
    final String contactName = _escapeHtml(activationRequestModel.contactName);
    final String requestId = _escapeHtml(activationRequestModel.id);
    final String userEmail = _escapeHtml(approvalRecipientEmail);
    final String approvedAtText = _escapeHtml(_formatTimestamp(approvedAt));
    final String expiresAtText = _escapeHtml(_formatTimestamp(expiresAt));

    return '''
<p>Your activation request has been approved successfully.</p>
<p>Your software access is now active.</p>
<p><strong>Contact name:</strong> $contactName</p>
<p><strong>User email:</strong> $userEmail</p>
<p><strong>Approved days:</strong> ${activationRequestModel.requestedDays}</p>
<p><strong>Total amount:</strong> Rs ${activationRequestModel.totalAmount}</p>
<p><strong>Request ID:</strong> $requestId</p>
<p><strong>Approved at:</strong> $approvedAtText</p>
<p><strong>Active until:</strong> $expiresAtText</p>
''';
  }

  String _formatTimestamp(DateTime dateTime) {
    final DateTime localDateTime = dateTime.toLocal();
    final String year = localDateTime.year.toString().padLeft(4, '0');
    final String month = localDateTime.month.toString().padLeft(2, '0');
    final String day = localDateTime.day.toString().padLeft(2, '0');
    final String hour = localDateTime.hour.toString().padLeft(2, '0');
    final String minute = localDateTime.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }

  String _escapeHtml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String? _extractBillingEmail(Map<String, dynamic>? billingInfo) {
    final dynamic emailValue = billingInfo?['email'];
    if (emailValue is! String) return null;

    final String trimmedEmail = emailValue.trim();
    if (trimmedEmail.isEmpty) return null;

    return trimmedEmail;
  }

  void _logEmailDeliveryFailure({
    required String emailKindLabel,
    required Object error,
  }) {
    debugPrint(
      'Failed to send $emailKindLabel email: ${_describeEmailDeliveryFailure(error)}',
    );
  }

  String _describeEmailDeliveryFailure(Object error) {
    if (error is DioException) {
      final Response<dynamic>? response = error.response;
      if (response != null) {
        final String statusCodeText =
            response.statusCode?.toString() ?? 'unknown';
        final String statusMessageText =
            response.statusMessage?.trim().isNotEmpty == true
            ? response.statusMessage!.trim()
            : 'No status message returned.';
        final String responseBodyText = _stringifyResponseBody(response.data);

        return 'HTTP $statusCodeText. $statusMessageText Response: $responseBodyText';
      }

      final String baseMessage = _extractDioMessage(error);
      return baseMessage;
    }

    return error.toString();
  }

  String _extractDioMessage(DioException error) {
    final String explicitMessage = error.message?.trim() ?? '';
    if (explicitMessage.isNotEmpty) {
      return explicitMessage;
    }

    final Object? innerError = error.error;
    if (innerError != null) {
      final String innerErrorMessage = innerError.toString().trim();
      if (innerErrorMessage.isNotEmpty) {
        return innerErrorMessage;
      }
    }

    return error.toString();
  }

  String _stringifyResponseBody(dynamic responseBody) {
    if (responseBody == null) {
      return 'No response body returned.';
    }

    final String responseText = responseBody.toString().trim();
    if (responseText.isEmpty) {
      return 'Empty response body.';
    }

    return responseText;
  }
}
