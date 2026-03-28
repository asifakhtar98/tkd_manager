// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_medal_placement_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketMedalPlacementEntity {

/// The participant who secured this medal.
 String get participantId;/// Absolute numerical rank status (1 = Gold, 2 = Silver, 3 = Bronze A, 4 = Bronze B).
 int get rankStatus;/// Verbose human-readable label for UI rendering (e.g., "1st", "2nd", "3rd").
 String get displayPlacementLabel;
/// Create a copy of BracketMedalPlacementEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketMedalPlacementEntityCopyWith<BracketMedalPlacementEntity> get copyWith => _$BracketMedalPlacementEntityCopyWithImpl<BracketMedalPlacementEntity>(this as BracketMedalPlacementEntity, _$identity);

  /// Serializes this BracketMedalPlacementEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketMedalPlacementEntity&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.rankStatus, rankStatus) || other.rankStatus == rankStatus)&&(identical(other.displayPlacementLabel, displayPlacementLabel) || other.displayPlacementLabel == displayPlacementLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,rankStatus,displayPlacementLabel);

@override
String toString() {
  return 'BracketMedalPlacementEntity(participantId: $participantId, rankStatus: $rankStatus, displayPlacementLabel: $displayPlacementLabel)';
}


}

/// @nodoc
abstract mixin class $BracketMedalPlacementEntityCopyWith<$Res>  {
  factory $BracketMedalPlacementEntityCopyWith(BracketMedalPlacementEntity value, $Res Function(BracketMedalPlacementEntity) _then) = _$BracketMedalPlacementEntityCopyWithImpl;
@useResult
$Res call({
 String participantId, int rankStatus, String displayPlacementLabel
});




}
/// @nodoc
class _$BracketMedalPlacementEntityCopyWithImpl<$Res>
    implements $BracketMedalPlacementEntityCopyWith<$Res> {
  _$BracketMedalPlacementEntityCopyWithImpl(this._self, this._then);

  final BracketMedalPlacementEntity _self;
  final $Res Function(BracketMedalPlacementEntity) _then;

/// Create a copy of BracketMedalPlacementEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? rankStatus = null,Object? displayPlacementLabel = null,}) {
  return _then(_self.copyWith(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,rankStatus: null == rankStatus ? _self.rankStatus : rankStatus // ignore: cast_nullable_to_non_nullable
as int,displayPlacementLabel: null == displayPlacementLabel ? _self.displayPlacementLabel : displayPlacementLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketMedalPlacementEntity].
extension BracketMedalPlacementEntityPatterns on BracketMedalPlacementEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketMedalPlacementEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketMedalPlacementEntity value)  $default,){
final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketMedalPlacementEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  int rankStatus,  String displayPlacementLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity() when $default != null:
return $default(_that.participantId,_that.rankStatus,_that.displayPlacementLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  int rankStatus,  String displayPlacementLabel)  $default,) {final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity():
return $default(_that.participantId,_that.rankStatus,_that.displayPlacementLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  int rankStatus,  String displayPlacementLabel)?  $default,) {final _that = this;
switch (_that) {
case _BracketMedalPlacementEntity() when $default != null:
return $default(_that.participantId,_that.rankStatus,_that.displayPlacementLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BracketMedalPlacementEntity implements BracketMedalPlacementEntity {
  const _BracketMedalPlacementEntity({required this.participantId, required this.rankStatus, required this.displayPlacementLabel});
  factory _BracketMedalPlacementEntity.fromJson(Map<String, dynamic> json) => _$BracketMedalPlacementEntityFromJson(json);

/// The participant who secured this medal.
@override final  String participantId;
/// Absolute numerical rank status (1 = Gold, 2 = Silver, 3 = Bronze A, 4 = Bronze B).
@override final  int rankStatus;
/// Verbose human-readable label for UI rendering (e.g., "1st", "2nd", "3rd").
@override final  String displayPlacementLabel;

/// Create a copy of BracketMedalPlacementEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketMedalPlacementEntityCopyWith<_BracketMedalPlacementEntity> get copyWith => __$BracketMedalPlacementEntityCopyWithImpl<_BracketMedalPlacementEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketMedalPlacementEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketMedalPlacementEntity&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.rankStatus, rankStatus) || other.rankStatus == rankStatus)&&(identical(other.displayPlacementLabel, displayPlacementLabel) || other.displayPlacementLabel == displayPlacementLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,rankStatus,displayPlacementLabel);

@override
String toString() {
  return 'BracketMedalPlacementEntity(participantId: $participantId, rankStatus: $rankStatus, displayPlacementLabel: $displayPlacementLabel)';
}


}

/// @nodoc
abstract mixin class _$BracketMedalPlacementEntityCopyWith<$Res> implements $BracketMedalPlacementEntityCopyWith<$Res> {
  factory _$BracketMedalPlacementEntityCopyWith(_BracketMedalPlacementEntity value, $Res Function(_BracketMedalPlacementEntity) _then) = __$BracketMedalPlacementEntityCopyWithImpl;
@override @useResult
$Res call({
 String participantId, int rankStatus, String displayPlacementLabel
});




}
/// @nodoc
class __$BracketMedalPlacementEntityCopyWithImpl<$Res>
    implements _$BracketMedalPlacementEntityCopyWith<$Res> {
  __$BracketMedalPlacementEntityCopyWithImpl(this._self, this._then);

  final _BracketMedalPlacementEntity _self;
  final $Res Function(_BracketMedalPlacementEntity) _then;

/// Create a copy of BracketMedalPlacementEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? rankStatus = null,Object? displayPlacementLabel = null,}) {
  return _then(_BracketMedalPlacementEntity(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,rankStatus: null == rankStatus ? _self.rankStatus : rankStatus // ignore: cast_nullable_to_non_nullable
as int,displayPlacementLabel: null == displayPlacementLabel ? _self.displayPlacementLabel : displayPlacementLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
