// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantEntity {

 String get id; String get divisionId; String get firstName; String get lastName; String? get schoolOrDojangName; String? get beltRank; String? get registrationId; int? get seedNumber; bool get isBye;
/// Create a copy of ParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantEntityCopyWith<ParticipantEntity> get copyWith => _$ParticipantEntityCopyWithImpl<ParticipantEntity>(this as ParticipantEntity, _$identity);

  /// Serializes this ParticipantEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.schoolOrDojangName, schoolOrDojangName) || other.schoolOrDojangName == schoolOrDojangName)&&(identical(other.beltRank, beltRank) || other.beltRank == beltRank)&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.seedNumber, seedNumber) || other.seedNumber == seedNumber)&&(identical(other.isBye, isBye) || other.isBye == isBye));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,divisionId,firstName,lastName,schoolOrDojangName,beltRank,registrationId,seedNumber,isBye);

@override
String toString() {
  return 'ParticipantEntity(id: $id, divisionId: $divisionId, firstName: $firstName, lastName: $lastName, schoolOrDojangName: $schoolOrDojangName, beltRank: $beltRank, registrationId: $registrationId, seedNumber: $seedNumber, isBye: $isBye)';
}


}

/// @nodoc
abstract mixin class $ParticipantEntityCopyWith<$Res>  {
  factory $ParticipantEntityCopyWith(ParticipantEntity value, $Res Function(ParticipantEntity) _then) = _$ParticipantEntityCopyWithImpl;
@useResult
$Res call({
 String id, String divisionId, String firstName, String lastName, String? schoolOrDojangName, String? beltRank, String? registrationId, int? seedNumber, bool isBye
});




}
/// @nodoc
class _$ParticipantEntityCopyWithImpl<$Res>
    implements $ParticipantEntityCopyWith<$Res> {
  _$ParticipantEntityCopyWithImpl(this._self, this._then);

  final ParticipantEntity _self;
  final $Res Function(ParticipantEntity) _then;

/// Create a copy of ParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? divisionId = null,Object? firstName = null,Object? lastName = null,Object? schoolOrDojangName = freezed,Object? beltRank = freezed,Object? registrationId = freezed,Object? seedNumber = freezed,Object? isBye = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,schoolOrDojangName: freezed == schoolOrDojangName ? _self.schoolOrDojangName : schoolOrDojangName // ignore: cast_nullable_to_non_nullable
as String?,beltRank: freezed == beltRank ? _self.beltRank : beltRank // ignore: cast_nullable_to_non_nullable
as String?,registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as String?,seedNumber: freezed == seedNumber ? _self.seedNumber : seedNumber // ignore: cast_nullable_to_non_nullable
as int?,isBye: null == isBye ? _self.isBye : isBye // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantEntity].
extension ParticipantEntityPatterns on ParticipantEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantEntity value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String divisionId,  String firstName,  String lastName,  String? schoolOrDojangName,  String? beltRank,  String? registrationId,  int? seedNumber,  bool isBye)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantEntity() when $default != null:
return $default(_that.id,_that.divisionId,_that.firstName,_that.lastName,_that.schoolOrDojangName,_that.beltRank,_that.registrationId,_that.seedNumber,_that.isBye);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String divisionId,  String firstName,  String lastName,  String? schoolOrDojangName,  String? beltRank,  String? registrationId,  int? seedNumber,  bool isBye)  $default,) {final _that = this;
switch (_that) {
case _ParticipantEntity():
return $default(_that.id,_that.divisionId,_that.firstName,_that.lastName,_that.schoolOrDojangName,_that.beltRank,_that.registrationId,_that.seedNumber,_that.isBye);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String divisionId,  String firstName,  String lastName,  String? schoolOrDojangName,  String? beltRank,  String? registrationId,  int? seedNumber,  bool isBye)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantEntity() when $default != null:
return $default(_that.id,_that.divisionId,_that.firstName,_that.lastName,_that.schoolOrDojangName,_that.beltRank,_that.registrationId,_that.seedNumber,_that.isBye);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantEntity implements ParticipantEntity {
  const _ParticipantEntity({required this.id, required this.divisionId, required this.firstName, required this.lastName, this.schoolOrDojangName, this.beltRank, this.registrationId, this.seedNumber, this.isBye = false});
  factory _ParticipantEntity.fromJson(Map<String, dynamic> json) => _$ParticipantEntityFromJson(json);

@override final  String id;
@override final  String divisionId;
@override final  String firstName;
@override final  String lastName;
@override final  String? schoolOrDojangName;
@override final  String? beltRank;
@override final  String? registrationId;
@override final  int? seedNumber;
@override@JsonKey() final  bool isBye;

/// Create a copy of ParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantEntityCopyWith<_ParticipantEntity> get copyWith => __$ParticipantEntityCopyWithImpl<_ParticipantEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.schoolOrDojangName, schoolOrDojangName) || other.schoolOrDojangName == schoolOrDojangName)&&(identical(other.beltRank, beltRank) || other.beltRank == beltRank)&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.seedNumber, seedNumber) || other.seedNumber == seedNumber)&&(identical(other.isBye, isBye) || other.isBye == isBye));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,divisionId,firstName,lastName,schoolOrDojangName,beltRank,registrationId,seedNumber,isBye);

@override
String toString() {
  return 'ParticipantEntity(id: $id, divisionId: $divisionId, firstName: $firstName, lastName: $lastName, schoolOrDojangName: $schoolOrDojangName, beltRank: $beltRank, registrationId: $registrationId, seedNumber: $seedNumber, isBye: $isBye)';
}


}

/// @nodoc
abstract mixin class _$ParticipantEntityCopyWith<$Res> implements $ParticipantEntityCopyWith<$Res> {
  factory _$ParticipantEntityCopyWith(_ParticipantEntity value, $Res Function(_ParticipantEntity) _then) = __$ParticipantEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String divisionId, String firstName, String lastName, String? schoolOrDojangName, String? beltRank, String? registrationId, int? seedNumber, bool isBye
});




}
/// @nodoc
class __$ParticipantEntityCopyWithImpl<$Res>
    implements _$ParticipantEntityCopyWith<$Res> {
  __$ParticipantEntityCopyWithImpl(this._self, this._then);

  final _ParticipantEntity _self;
  final $Res Function(_ParticipantEntity) _then;

/// Create a copy of ParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? divisionId = null,Object? firstName = null,Object? lastName = null,Object? schoolOrDojangName = freezed,Object? beltRank = freezed,Object? registrationId = freezed,Object? seedNumber = freezed,Object? isBye = null,}) {
  return _then(_ParticipantEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,schoolOrDojangName: freezed == schoolOrDojangName ? _self.schoolOrDojangName : schoolOrDojangName // ignore: cast_nullable_to_non_nullable
as String?,beltRank: freezed == beltRank ? _self.beltRank : beltRank // ignore: cast_nullable_to_non_nullable
as String?,registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as String?,seedNumber: freezed == seedNumber ? _self.seedNumber : seedNumber // ignore: cast_nullable_to_non_nullable
as int?,isBye: null == isBye ? _self.isBye : isBye // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
