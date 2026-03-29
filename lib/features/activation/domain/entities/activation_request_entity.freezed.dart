// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationRequestEntity {

 String get id; String get userId; String get contactName; int get requestedDays; int get totalAmount; String get status; DateTime get createdAt; DateTime? get reviewedAt;
/// Create a copy of ActivationRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationRequestEntityCopyWith<ActivationRequestEntity> get copyWith => _$ActivationRequestEntityCopyWithImpl<ActivationRequestEntity>(this as ActivationRequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,contactName,requestedDays,totalAmount,status,createdAt,reviewedAt);

@override
String toString() {
  return 'ActivationRequestEntity(id: $id, userId: $userId, contactName: $contactName, requestedDays: $requestedDays, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $ActivationRequestEntityCopyWith<$Res>  {
  factory $ActivationRequestEntityCopyWith(ActivationRequestEntity value, $Res Function(ActivationRequestEntity) _then) = _$ActivationRequestEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String contactName, int requestedDays, int totalAmount, String status, DateTime createdAt, DateTime? reviewedAt
});




}
/// @nodoc
class _$ActivationRequestEntityCopyWithImpl<$Res>
    implements $ActivationRequestEntityCopyWith<$Res> {
  _$ActivationRequestEntityCopyWithImpl(this._self, this._then);

  final ActivationRequestEntity _self;
  final $Res Function(ActivationRequestEntity) _then;

/// Create a copy of ActivationRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? contactName = null,Object? requestedDays = null,Object? totalAmount = null,Object? status = null,Object? createdAt = null,Object? reviewedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,requestedDays: null == requestedDays ? _self.requestedDays : requestedDays // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationRequestEntity].
extension ActivationRequestEntityPatterns on ActivationRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActivationRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String contactName,  int requestedDays,  int totalAmount,  String status,  DateTime createdAt,  DateTime? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationRequestEntity() when $default != null:
return $default(_that.id,_that.userId,_that.contactName,_that.requestedDays,_that.totalAmount,_that.status,_that.createdAt,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String contactName,  int requestedDays,  int totalAmount,  String status,  DateTime createdAt,  DateTime? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _ActivationRequestEntity():
return $default(_that.id,_that.userId,_that.contactName,_that.requestedDays,_that.totalAmount,_that.status,_that.createdAt,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String contactName,  int requestedDays,  int totalAmount,  String status,  DateTime createdAt,  DateTime? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivationRequestEntity() when $default != null:
return $default(_that.id,_that.userId,_that.contactName,_that.requestedDays,_that.totalAmount,_that.status,_that.createdAt,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationRequestEntity implements ActivationRequestEntity {
  const _ActivationRequestEntity({required this.id, required this.userId, required this.contactName, required this.requestedDays, required this.totalAmount, required this.status, required this.createdAt, this.reviewedAt});
  

@override final  String id;
@override final  String userId;
@override final  String contactName;
@override final  int requestedDays;
@override final  int totalAmount;
@override final  String status;
@override final  DateTime createdAt;
@override final  DateTime? reviewedAt;

/// Create a copy of ActivationRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationRequestEntityCopyWith<_ActivationRequestEntity> get copyWith => __$ActivationRequestEntityCopyWithImpl<_ActivationRequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,contactName,requestedDays,totalAmount,status,createdAt,reviewedAt);

@override
String toString() {
  return 'ActivationRequestEntity(id: $id, userId: $userId, contactName: $contactName, requestedDays: $requestedDays, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$ActivationRequestEntityCopyWith<$Res> implements $ActivationRequestEntityCopyWith<$Res> {
  factory _$ActivationRequestEntityCopyWith(_ActivationRequestEntity value, $Res Function(_ActivationRequestEntity) _then) = __$ActivationRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String contactName, int requestedDays, int totalAmount, String status, DateTime createdAt, DateTime? reviewedAt
});




}
/// @nodoc
class __$ActivationRequestEntityCopyWithImpl<$Res>
    implements _$ActivationRequestEntityCopyWith<$Res> {
  __$ActivationRequestEntityCopyWithImpl(this._self, this._then);

  final _ActivationRequestEntity _self;
  final $Res Function(_ActivationRequestEntity) _then;

/// Create a copy of ActivationRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? contactName = null,Object? requestedDays = null,Object? totalAmount = null,Object? status = null,Object? createdAt = null,Object? reviewedAt = freezed,}) {
  return _then(_ActivationRequestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,requestedDays: null == requestedDays ? _self.requestedDays : requestedDays // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
