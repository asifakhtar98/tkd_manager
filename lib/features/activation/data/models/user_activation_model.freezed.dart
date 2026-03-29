// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivationModel {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'expires_at') DateTime get expiresAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of UserActivationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivationModelCopyWith<UserActivationModel> get copyWith => _$UserActivationModelCopyWithImpl<UserActivationModel>(this as UserActivationModel, _$identity);

  /// Serializes this UserActivationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivationModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,expiresAt,updatedAt);

@override
String toString() {
  return 'UserActivationModel(userId: $userId, expiresAt: $expiresAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserActivationModelCopyWith<$Res>  {
  factory $UserActivationModelCopyWith(UserActivationModel value, $Res Function(UserActivationModel) _then) = _$UserActivationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$UserActivationModelCopyWithImpl<$Res>
    implements $UserActivationModelCopyWith<$Res> {
  _$UserActivationModelCopyWithImpl(this._self, this._then);

  final UserActivationModel _self;
  final $Res Function(UserActivationModel) _then;

/// Create a copy of UserActivationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? expiresAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserActivationModel].
extension UserActivationModelPatterns on UserActivationModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivationModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivationModel value)  $default,){
final _that = this;
switch (_that) {
case _UserActivationModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivationModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivationModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivationModel() when $default != null:
return $default(_that.userId,_that.expiresAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserActivationModel():
return $default(_that.userId,_that.expiresAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserActivationModel() when $default != null:
return $default(_that.userId,_that.expiresAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivationModel implements UserActivationModel {
  const _UserActivationModel({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _UserActivationModel.fromJson(Map<String, dynamic> json) => _$UserActivationModelFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of UserActivationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivationModelCopyWith<_UserActivationModel> get copyWith => __$UserActivationModelCopyWithImpl<_UserActivationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivationModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,expiresAt,updatedAt);

@override
String toString() {
  return 'UserActivationModel(userId: $userId, expiresAt: $expiresAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserActivationModelCopyWith<$Res> implements $UserActivationModelCopyWith<$Res> {
  factory _$UserActivationModelCopyWith(_UserActivationModel value, $Res Function(_UserActivationModel) _then) = __$UserActivationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$UserActivationModelCopyWithImpl<$Res>
    implements _$UserActivationModelCopyWith<$Res> {
  __$UserActivationModelCopyWithImpl(this._self, this._then);

  final _UserActivationModel _self;
  final $Res Function(_UserActivationModel) _then;

/// Create a copy of UserActivationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? expiresAt = null,Object? updatedAt = null,}) {
  return _then(_UserActivationModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
