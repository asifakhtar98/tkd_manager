// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketEntity {

 String get id; String get divisionId; BracketType get bracketType; int get totalRounds; DateTime get createdAtTimestamp; DateTime get updatedAtTimestamp; String? get poolIdentifier; bool get isFinalized; DateTime? get generatedAtTimestamp; DateTime? get finalizedAtTimestamp; Map<String, dynamic>? get bracketDataJson; int get syncVersion; bool get isDeleted; DateTime? get deletedAtTimestamp; bool get isDemoData;
/// Create a copy of BracketEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<BracketEntity> get copyWith => _$BracketEntityCopyWithImpl<BracketEntity>(this as BracketEntity, _$identity);

  /// Serializes this BracketEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.bracketType, bracketType) || other.bracketType == bracketType)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds)&&(identical(other.createdAtTimestamp, createdAtTimestamp) || other.createdAtTimestamp == createdAtTimestamp)&&(identical(other.updatedAtTimestamp, updatedAtTimestamp) || other.updatedAtTimestamp == updatedAtTimestamp)&&(identical(other.poolIdentifier, poolIdentifier) || other.poolIdentifier == poolIdentifier)&&(identical(other.isFinalized, isFinalized) || other.isFinalized == isFinalized)&&(identical(other.generatedAtTimestamp, generatedAtTimestamp) || other.generatedAtTimestamp == generatedAtTimestamp)&&(identical(other.finalizedAtTimestamp, finalizedAtTimestamp) || other.finalizedAtTimestamp == finalizedAtTimestamp)&&const DeepCollectionEquality().equals(other.bracketDataJson, bracketDataJson)&&(identical(other.syncVersion, syncVersion) || other.syncVersion == syncVersion)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAtTimestamp, deletedAtTimestamp) || other.deletedAtTimestamp == deletedAtTimestamp)&&(identical(other.isDemoData, isDemoData) || other.isDemoData == isDemoData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,divisionId,bracketType,totalRounds,createdAtTimestamp,updatedAtTimestamp,poolIdentifier,isFinalized,generatedAtTimestamp,finalizedAtTimestamp,const DeepCollectionEquality().hash(bracketDataJson),syncVersion,isDeleted,deletedAtTimestamp,isDemoData);

@override
String toString() {
  return 'BracketEntity(id: $id, divisionId: $divisionId, bracketType: $bracketType, totalRounds: $totalRounds, createdAtTimestamp: $createdAtTimestamp, updatedAtTimestamp: $updatedAtTimestamp, poolIdentifier: $poolIdentifier, isFinalized: $isFinalized, generatedAtTimestamp: $generatedAtTimestamp, finalizedAtTimestamp: $finalizedAtTimestamp, bracketDataJson: $bracketDataJson, syncVersion: $syncVersion, isDeleted: $isDeleted, deletedAtTimestamp: $deletedAtTimestamp, isDemoData: $isDemoData)';
}


}

/// @nodoc
abstract mixin class $BracketEntityCopyWith<$Res>  {
  factory $BracketEntityCopyWith(BracketEntity value, $Res Function(BracketEntity) _then) = _$BracketEntityCopyWithImpl;
@useResult
$Res call({
 String id, String divisionId, BracketType bracketType, int totalRounds, DateTime createdAtTimestamp, DateTime updatedAtTimestamp, String? poolIdentifier, bool isFinalized, DateTime? generatedAtTimestamp, DateTime? finalizedAtTimestamp, Map<String, dynamic>? bracketDataJson, int syncVersion, bool isDeleted, DateTime? deletedAtTimestamp, bool isDemoData
});




}
/// @nodoc
class _$BracketEntityCopyWithImpl<$Res>
    implements $BracketEntityCopyWith<$Res> {
  _$BracketEntityCopyWithImpl(this._self, this._then);

  final BracketEntity _self;
  final $Res Function(BracketEntity) _then;

/// Create a copy of BracketEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? divisionId = null,Object? bracketType = null,Object? totalRounds = null,Object? createdAtTimestamp = null,Object? updatedAtTimestamp = null,Object? poolIdentifier = freezed,Object? isFinalized = null,Object? generatedAtTimestamp = freezed,Object? finalizedAtTimestamp = freezed,Object? bracketDataJson = freezed,Object? syncVersion = null,Object? isDeleted = null,Object? deletedAtTimestamp = freezed,Object? isDemoData = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,bracketType: null == bracketType ? _self.bracketType : bracketType // ignore: cast_nullable_to_non_nullable
as BracketType,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,createdAtTimestamp: null == createdAtTimestamp ? _self.createdAtTimestamp : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtTimestamp: null == updatedAtTimestamp ? _self.updatedAtTimestamp : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,poolIdentifier: freezed == poolIdentifier ? _self.poolIdentifier : poolIdentifier // ignore: cast_nullable_to_non_nullable
as String?,isFinalized: null == isFinalized ? _self.isFinalized : isFinalized // ignore: cast_nullable_to_non_nullable
as bool,generatedAtTimestamp: freezed == generatedAtTimestamp ? _self.generatedAtTimestamp : generatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,finalizedAtTimestamp: freezed == finalizedAtTimestamp ? _self.finalizedAtTimestamp : finalizedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,bracketDataJson: freezed == bracketDataJson ? _self.bracketDataJson : bracketDataJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,syncVersion: null == syncVersion ? _self.syncVersion : syncVersion // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,deletedAtTimestamp: freezed == deletedAtTimestamp ? _self.deletedAtTimestamp : deletedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,isDemoData: null == isDemoData ? _self.isDemoData : isDemoData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketEntity].
extension BracketEntityPatterns on BracketEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketEntity value)  $default,){
final _that = this;
switch (_that) {
case _BracketEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BracketEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String divisionId,  BracketType bracketType,  int totalRounds,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? poolIdentifier,  bool isFinalized,  DateTime? generatedAtTimestamp,  DateTime? finalizedAtTimestamp,  Map<String, dynamic>? bracketDataJson,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  bool isDemoData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketEntity() when $default != null:
return $default(_that.id,_that.divisionId,_that.bracketType,_that.totalRounds,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.poolIdentifier,_that.isFinalized,_that.generatedAtTimestamp,_that.finalizedAtTimestamp,_that.bracketDataJson,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.isDemoData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String divisionId,  BracketType bracketType,  int totalRounds,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? poolIdentifier,  bool isFinalized,  DateTime? generatedAtTimestamp,  DateTime? finalizedAtTimestamp,  Map<String, dynamic>? bracketDataJson,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  bool isDemoData)  $default,) {final _that = this;
switch (_that) {
case _BracketEntity():
return $default(_that.id,_that.divisionId,_that.bracketType,_that.totalRounds,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.poolIdentifier,_that.isFinalized,_that.generatedAtTimestamp,_that.finalizedAtTimestamp,_that.bracketDataJson,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.isDemoData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String divisionId,  BracketType bracketType,  int totalRounds,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? poolIdentifier,  bool isFinalized,  DateTime? generatedAtTimestamp,  DateTime? finalizedAtTimestamp,  Map<String, dynamic>? bracketDataJson,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  bool isDemoData)?  $default,) {final _that = this;
switch (_that) {
case _BracketEntity() when $default != null:
return $default(_that.id,_that.divisionId,_that.bracketType,_that.totalRounds,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.poolIdentifier,_that.isFinalized,_that.generatedAtTimestamp,_that.finalizedAtTimestamp,_that.bracketDataJson,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.isDemoData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BracketEntity implements BracketEntity {
  const _BracketEntity({required this.id, required this.divisionId, required this.bracketType, required this.totalRounds, required this.createdAtTimestamp, required this.updatedAtTimestamp, this.poolIdentifier, this.isFinalized = false, this.generatedAtTimestamp, this.finalizedAtTimestamp, final  Map<String, dynamic>? bracketDataJson, this.syncVersion = 1, this.isDeleted = false, this.deletedAtTimestamp, this.isDemoData = false}): _bracketDataJson = bracketDataJson;
  factory _BracketEntity.fromJson(Map<String, dynamic> json) => _$BracketEntityFromJson(json);

@override final  String id;
@override final  String divisionId;
@override final  BracketType bracketType;
@override final  int totalRounds;
@override final  DateTime createdAtTimestamp;
@override final  DateTime updatedAtTimestamp;
@override final  String? poolIdentifier;
@override@JsonKey() final  bool isFinalized;
@override final  DateTime? generatedAtTimestamp;
@override final  DateTime? finalizedAtTimestamp;
 final  Map<String, dynamic>? _bracketDataJson;
@override Map<String, dynamic>? get bracketDataJson {
  final value = _bracketDataJson;
  if (value == null) return null;
  if (_bracketDataJson is EqualUnmodifiableMapView) return _bracketDataJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  int syncVersion;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime? deletedAtTimestamp;
@override@JsonKey() final  bool isDemoData;

/// Create a copy of BracketEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketEntityCopyWith<_BracketEntity> get copyWith => __$BracketEntityCopyWithImpl<_BracketEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.bracketType, bracketType) || other.bracketType == bracketType)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds)&&(identical(other.createdAtTimestamp, createdAtTimestamp) || other.createdAtTimestamp == createdAtTimestamp)&&(identical(other.updatedAtTimestamp, updatedAtTimestamp) || other.updatedAtTimestamp == updatedAtTimestamp)&&(identical(other.poolIdentifier, poolIdentifier) || other.poolIdentifier == poolIdentifier)&&(identical(other.isFinalized, isFinalized) || other.isFinalized == isFinalized)&&(identical(other.generatedAtTimestamp, generatedAtTimestamp) || other.generatedAtTimestamp == generatedAtTimestamp)&&(identical(other.finalizedAtTimestamp, finalizedAtTimestamp) || other.finalizedAtTimestamp == finalizedAtTimestamp)&&const DeepCollectionEquality().equals(other._bracketDataJson, _bracketDataJson)&&(identical(other.syncVersion, syncVersion) || other.syncVersion == syncVersion)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAtTimestamp, deletedAtTimestamp) || other.deletedAtTimestamp == deletedAtTimestamp)&&(identical(other.isDemoData, isDemoData) || other.isDemoData == isDemoData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,divisionId,bracketType,totalRounds,createdAtTimestamp,updatedAtTimestamp,poolIdentifier,isFinalized,generatedAtTimestamp,finalizedAtTimestamp,const DeepCollectionEquality().hash(_bracketDataJson),syncVersion,isDeleted,deletedAtTimestamp,isDemoData);

@override
String toString() {
  return 'BracketEntity(id: $id, divisionId: $divisionId, bracketType: $bracketType, totalRounds: $totalRounds, createdAtTimestamp: $createdAtTimestamp, updatedAtTimestamp: $updatedAtTimestamp, poolIdentifier: $poolIdentifier, isFinalized: $isFinalized, generatedAtTimestamp: $generatedAtTimestamp, finalizedAtTimestamp: $finalizedAtTimestamp, bracketDataJson: $bracketDataJson, syncVersion: $syncVersion, isDeleted: $isDeleted, deletedAtTimestamp: $deletedAtTimestamp, isDemoData: $isDemoData)';
}


}

/// @nodoc
abstract mixin class _$BracketEntityCopyWith<$Res> implements $BracketEntityCopyWith<$Res> {
  factory _$BracketEntityCopyWith(_BracketEntity value, $Res Function(_BracketEntity) _then) = __$BracketEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String divisionId, BracketType bracketType, int totalRounds, DateTime createdAtTimestamp, DateTime updatedAtTimestamp, String? poolIdentifier, bool isFinalized, DateTime? generatedAtTimestamp, DateTime? finalizedAtTimestamp, Map<String, dynamic>? bracketDataJson, int syncVersion, bool isDeleted, DateTime? deletedAtTimestamp, bool isDemoData
});




}
/// @nodoc
class __$BracketEntityCopyWithImpl<$Res>
    implements _$BracketEntityCopyWith<$Res> {
  __$BracketEntityCopyWithImpl(this._self, this._then);

  final _BracketEntity _self;
  final $Res Function(_BracketEntity) _then;

/// Create a copy of BracketEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? divisionId = null,Object? bracketType = null,Object? totalRounds = null,Object? createdAtTimestamp = null,Object? updatedAtTimestamp = null,Object? poolIdentifier = freezed,Object? isFinalized = null,Object? generatedAtTimestamp = freezed,Object? finalizedAtTimestamp = freezed,Object? bracketDataJson = freezed,Object? syncVersion = null,Object? isDeleted = null,Object? deletedAtTimestamp = freezed,Object? isDemoData = null,}) {
  return _then(_BracketEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,bracketType: null == bracketType ? _self.bracketType : bracketType // ignore: cast_nullable_to_non_nullable
as BracketType,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,createdAtTimestamp: null == createdAtTimestamp ? _self.createdAtTimestamp : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtTimestamp: null == updatedAtTimestamp ? _self.updatedAtTimestamp : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,poolIdentifier: freezed == poolIdentifier ? _self.poolIdentifier : poolIdentifier // ignore: cast_nullable_to_non_nullable
as String?,isFinalized: null == isFinalized ? _self.isFinalized : isFinalized // ignore: cast_nullable_to_non_nullable
as bool,generatedAtTimestamp: freezed == generatedAtTimestamp ? _self.generatedAtTimestamp : generatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,finalizedAtTimestamp: freezed == finalizedAtTimestamp ? _self.finalizedAtTimestamp : finalizedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,bracketDataJson: freezed == bracketDataJson ? _self._bracketDataJson : bracketDataJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,syncVersion: null == syncVersion ? _self.syncVersion : syncVersion // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,deletedAtTimestamp: freezed == deletedAtTimestamp ? _self.deletedAtTimestamp : deletedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,isDemoData: null == isDemoData ? _self.isDemoData : isDemoData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
