// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivationRequestModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'contact_name') String get contactName;@JsonKey(name: 'requested_days') int get requestedDays;@JsonKey(name: 'total_amount') int get totalAmount; String get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'reviewed_at') DateTime? get reviewedAt;
/// Create a copy of ActivationRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationRequestModelCopyWith<ActivationRequestModel> get copyWith => _$ActivationRequestModelCopyWithImpl<ActivationRequestModel>(this as ActivationRequestModel, _$identity);

  /// Serializes this ActivationRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,contactName,requestedDays,totalAmount,status,createdAt,reviewedAt);

@override
String toString() {
  return 'ActivationRequestModel(id: $id, userId: $userId, contactName: $contactName, requestedDays: $requestedDays, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $ActivationRequestModelCopyWith<$Res>  {
  factory $ActivationRequestModelCopyWith(ActivationRequestModel value, $Res Function(ActivationRequestModel) _then) = _$ActivationRequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'contact_name') String contactName,@JsonKey(name: 'requested_days') int requestedDays,@JsonKey(name: 'total_amount') int totalAmount, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt
});




}
/// @nodoc
class _$ActivationRequestModelCopyWithImpl<$Res>
    implements $ActivationRequestModelCopyWith<$Res> {
  _$ActivationRequestModelCopyWithImpl(this._self, this._then);

  final ActivationRequestModel _self;
  final $Res Function(ActivationRequestModel) _then;

/// Create a copy of ActivationRequestModel
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


/// Adds pattern-matching-related methods to [ActivationRequestModel].
extension ActivationRequestModelPatterns on ActivationRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'contact_name')  String contactName, @JsonKey(name: 'requested_days')  int requestedDays, @JsonKey(name: 'total_amount')  int totalAmount,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationRequestModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'contact_name')  String contactName, @JsonKey(name: 'requested_days')  int requestedDays, @JsonKey(name: 'total_amount')  int totalAmount,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _ActivationRequestModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'contact_name')  String contactName, @JsonKey(name: 'requested_days')  int requestedDays, @JsonKey(name: 'total_amount')  int totalAmount,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivationRequestModel() when $default != null:
return $default(_that.id,_that.userId,_that.contactName,_that.requestedDays,_that.totalAmount,_that.status,_that.createdAt,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationRequestModel implements ActivationRequestModel {
  const _ActivationRequestModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'contact_name') required this.contactName, @JsonKey(name: 'requested_days') required this.requestedDays, @JsonKey(name: 'total_amount') required this.totalAmount, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'reviewed_at') this.reviewedAt});
  factory _ActivationRequestModel.fromJson(Map<String, dynamic> json) => _$ActivationRequestModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'contact_name') final  String contactName;
@override@JsonKey(name: 'requested_days') final  int requestedDays;
@override@JsonKey(name: 'total_amount') final  int totalAmount;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'reviewed_at') final  DateTime? reviewedAt;

/// Create a copy of ActivationRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationRequestModelCopyWith<_ActivationRequestModel> get copyWith => __$ActivationRequestModelCopyWithImpl<_ActivationRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,contactName,requestedDays,totalAmount,status,createdAt,reviewedAt);

@override
String toString() {
  return 'ActivationRequestModel(id: $id, userId: $userId, contactName: $contactName, requestedDays: $requestedDays, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$ActivationRequestModelCopyWith<$Res> implements $ActivationRequestModelCopyWith<$Res> {
  factory _$ActivationRequestModelCopyWith(_ActivationRequestModel value, $Res Function(_ActivationRequestModel) _then) = __$ActivationRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'contact_name') String contactName,@JsonKey(name: 'requested_days') int requestedDays,@JsonKey(name: 'total_amount') int totalAmount, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt
});




}
/// @nodoc
class __$ActivationRequestModelCopyWithImpl<$Res>
    implements _$ActivationRequestModelCopyWith<$Res> {
  __$ActivationRequestModelCopyWithImpl(this._self, this._then);

  final _ActivationRequestModel _self;
  final $Res Function(_ActivationRequestModel) _then;

/// Create a copy of ActivationRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? contactName = null,Object? requestedDays = null,Object? totalAmount = null,Object? status = null,Object? createdAt = null,Object? reviewedAt = freezed,}) {
  return _then(_ActivationRequestModel(
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
