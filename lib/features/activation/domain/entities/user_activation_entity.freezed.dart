// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserActivationEntity {

 String get userId; DateTime get expiresAt; DateTime get updatedAt;
/// Create a copy of UserActivationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivationEntityCopyWith<UserActivationEntity> get copyWith => _$UserActivationEntityCopyWithImpl<UserActivationEntity>(this as UserActivationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivationEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,expiresAt,updatedAt);

@override
String toString() {
  return 'UserActivationEntity(userId: $userId, expiresAt: $expiresAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserActivationEntityCopyWith<$Res>  {
  factory $UserActivationEntityCopyWith(UserActivationEntity value, $Res Function(UserActivationEntity) _then) = _$UserActivationEntityCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime expiresAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserActivationEntityCopyWithImpl<$Res>
    implements $UserActivationEntityCopyWith<$Res> {
  _$UserActivationEntityCopyWithImpl(this._self, this._then);

  final UserActivationEntity _self;
  final $Res Function(UserActivationEntity) _then;

/// Create a copy of UserActivationEntity
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


/// Adds pattern-matching-related methods to [UserActivationEntity].
extension UserActivationEntityPatterns on UserActivationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivationEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserActivationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime expiresAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivationEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime expiresAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserActivationEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime expiresAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserActivationEntity() when $default != null:
return $default(_that.userId,_that.expiresAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserActivationEntity implements UserActivationEntity {
  const _UserActivationEntity({required this.userId, required this.expiresAt, required this.updatedAt});
  

@override final  String userId;
@override final  DateTime expiresAt;
@override final  DateTime updatedAt;

/// Create a copy of UserActivationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivationEntityCopyWith<_UserActivationEntity> get copyWith => __$UserActivationEntityCopyWithImpl<_UserActivationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivationEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,expiresAt,updatedAt);

@override
String toString() {
  return 'UserActivationEntity(userId: $userId, expiresAt: $expiresAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserActivationEntityCopyWith<$Res> implements $UserActivationEntityCopyWith<$Res> {
  factory _$UserActivationEntityCopyWith(_UserActivationEntity value, $Res Function(_UserActivationEntity) _then) = __$UserActivationEntityCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime expiresAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserActivationEntityCopyWithImpl<$Res>
    implements _$UserActivationEntityCopyWith<$Res> {
  __$UserActivationEntityCopyWithImpl(this._self, this._then);

  final _UserActivationEntity _self;
  final $Res Function(_UserActivationEntity) _then;

/// Create a copy of UserActivationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? expiresAt = null,Object? updatedAt = null,}) {
  return _then(_UserActivationEntity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
