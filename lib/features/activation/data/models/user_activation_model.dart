import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_activation_entity.dart';

part 'user_activation_model.freezed.dart';
part 'user_activation_model.g.dart';

/// Data model for the `user_activations` Supabase table.
///
/// Maps JSON column names (snake_case) to Dart fields (camelCase)
/// and provides lossless conversion to the domain entity.
@freezed
abstract class UserActivationModel with _$UserActivationModel {
  const factory UserActivationModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserActivationModel;

  factory UserActivationModel.fromJson(Map<String, dynamic> json) =>
      _$UserActivationModelFromJson(json);
}

extension UserActivationModelToDomain on UserActivationModel {
  UserActivationEntity toDomain() {
    return UserActivationEntity(
      userId: userId,
      expiresAt: expiresAt,
      updatedAt: updatedAt,
    );
  }
}
