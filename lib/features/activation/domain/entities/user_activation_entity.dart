import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activation_entity.freezed.dart';

/// Represents a user's active software subscription.
@freezed
abstract class UserActivationEntity with _$UserActivationEntity {
  const factory UserActivationEntity({
    required String userId,
    required DateTime expiresAt,
    required DateTime updatedAt,
  }) = _UserActivationEntity;
}
