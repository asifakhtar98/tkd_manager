// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchEntity {

/// Unique identifier for this match (UUID v4).
 String get id;/// The bracket this match belongs to.
 String get bracketId;/// 1-based round number within the bracket.
 int get roundNumber;/// 1-based position of this match within its round.
 int get matchNumberInRound;/// Timestamp when the match record was created.
 DateTime get createdAtTimestamp;/// Timestamp of the most recent update.
 DateTime get updatedAtTimestamp;/// ID of the participant in the red corner (null if unassigned / BYE).
 String? get participantRedId;/// ID of the participant in the blue corner (null if unassigned / BYE).
 String? get participantBlueId;/// ID of the victorious participant (null until result is recorded).
 String? get winnerId;/// Match ID to which the winner advances (null for final match).
 String? get winnerAdvancesToMatchId;/// Match ID to which the loser drops (only in double-elimination).
 String? get loserAdvancesToMatchId;/// Assigned ring / mat number for the match.
 int? get scheduledRingNumber;/// Scheduled start time.
 DateTime? get scheduledTime;/// Current lifecycle status of the match.
 MatchStatus get status;/// How the match was decided (null if not yet completed).
 MatchResultType? get resultType;/// Free-form notes attached to the match.
 String? get notes;/// Score awarded to the blue-corner participant.
 int? get blueScore;/// Score awarded to the red-corner participant.
 int? get redScore;/// Timestamp when the match started.
 DateTime? get startedAtTimestamp;/// Timestamp when the match was completed.
 DateTime? get completedAtTimestamp;/// Optimistic concurrency version counter.
 int get syncVersion;/// Soft-delete flag.
 bool get isDeleted;/// Timestamp of soft deletion, if applicable.
 DateTime? get deletedAtTimestamp;/// Global display sequential number assigned across the entire Tie Sheet.
/// Computed once during bracket creation phase to preserve chronological integrity.
/// Example: 34 translates to "Match #34" in the Canvas UI.
 int? get globalMatchDisplayNumber;
/// Create a copy of MatchEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchEntityCopyWith<MatchEntity> get copyWith => _$MatchEntityCopyWithImpl<MatchEntity>(this as MatchEntity, _$identity);

  /// Serializes this MatchEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bracketId, bracketId) || other.bracketId == bracketId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.matchNumberInRound, matchNumberInRound) || other.matchNumberInRound == matchNumberInRound)&&(identical(other.createdAtTimestamp, createdAtTimestamp) || other.createdAtTimestamp == createdAtTimestamp)&&(identical(other.updatedAtTimestamp, updatedAtTimestamp) || other.updatedAtTimestamp == updatedAtTimestamp)&&(identical(other.participantRedId, participantRedId) || other.participantRedId == participantRedId)&&(identical(other.participantBlueId, participantBlueId) || other.participantBlueId == participantBlueId)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.winnerAdvancesToMatchId, winnerAdvancesToMatchId) || other.winnerAdvancesToMatchId == winnerAdvancesToMatchId)&&(identical(other.loserAdvancesToMatchId, loserAdvancesToMatchId) || other.loserAdvancesToMatchId == loserAdvancesToMatchId)&&(identical(other.scheduledRingNumber, scheduledRingNumber) || other.scheduledRingNumber == scheduledRingNumber)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.resultType, resultType) || other.resultType == resultType)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.blueScore, blueScore) || other.blueScore == blueScore)&&(identical(other.redScore, redScore) || other.redScore == redScore)&&(identical(other.startedAtTimestamp, startedAtTimestamp) || other.startedAtTimestamp == startedAtTimestamp)&&(identical(other.completedAtTimestamp, completedAtTimestamp) || other.completedAtTimestamp == completedAtTimestamp)&&(identical(other.syncVersion, syncVersion) || other.syncVersion == syncVersion)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAtTimestamp, deletedAtTimestamp) || other.deletedAtTimestamp == deletedAtTimestamp)&&(identical(other.globalMatchDisplayNumber, globalMatchDisplayNumber) || other.globalMatchDisplayNumber == globalMatchDisplayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,bracketId,roundNumber,matchNumberInRound,createdAtTimestamp,updatedAtTimestamp,participantRedId,participantBlueId,winnerId,winnerAdvancesToMatchId,loserAdvancesToMatchId,scheduledRingNumber,scheduledTime,status,resultType,notes,blueScore,redScore,startedAtTimestamp,completedAtTimestamp,syncVersion,isDeleted,deletedAtTimestamp,globalMatchDisplayNumber]);

@override
String toString() {
  return 'MatchEntity(id: $id, bracketId: $bracketId, roundNumber: $roundNumber, matchNumberInRound: $matchNumberInRound, createdAtTimestamp: $createdAtTimestamp, updatedAtTimestamp: $updatedAtTimestamp, participantRedId: $participantRedId, participantBlueId: $participantBlueId, winnerId: $winnerId, winnerAdvancesToMatchId: $winnerAdvancesToMatchId, loserAdvancesToMatchId: $loserAdvancesToMatchId, scheduledRingNumber: $scheduledRingNumber, scheduledTime: $scheduledTime, status: $status, resultType: $resultType, notes: $notes, blueScore: $blueScore, redScore: $redScore, startedAtTimestamp: $startedAtTimestamp, completedAtTimestamp: $completedAtTimestamp, syncVersion: $syncVersion, isDeleted: $isDeleted, deletedAtTimestamp: $deletedAtTimestamp, globalMatchDisplayNumber: $globalMatchDisplayNumber)';
}


}

/// @nodoc
abstract mixin class $MatchEntityCopyWith<$Res>  {
  factory $MatchEntityCopyWith(MatchEntity value, $Res Function(MatchEntity) _then) = _$MatchEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bracketId, int roundNumber, int matchNumberInRound, DateTime createdAtTimestamp, DateTime updatedAtTimestamp, String? participantRedId, String? participantBlueId, String? winnerId, String? winnerAdvancesToMatchId, String? loserAdvancesToMatchId, int? scheduledRingNumber, DateTime? scheduledTime, MatchStatus status, MatchResultType? resultType, String? notes, int? blueScore, int? redScore, DateTime? startedAtTimestamp, DateTime? completedAtTimestamp, int syncVersion, bool isDeleted, DateTime? deletedAtTimestamp, int? globalMatchDisplayNumber
});




}
/// @nodoc
class _$MatchEntityCopyWithImpl<$Res>
    implements $MatchEntityCopyWith<$Res> {
  _$MatchEntityCopyWithImpl(this._self, this._then);

  final MatchEntity _self;
  final $Res Function(MatchEntity) _then;

/// Create a copy of MatchEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bracketId = null,Object? roundNumber = null,Object? matchNumberInRound = null,Object? createdAtTimestamp = null,Object? updatedAtTimestamp = null,Object? participantRedId = freezed,Object? participantBlueId = freezed,Object? winnerId = freezed,Object? winnerAdvancesToMatchId = freezed,Object? loserAdvancesToMatchId = freezed,Object? scheduledRingNumber = freezed,Object? scheduledTime = freezed,Object? status = null,Object? resultType = freezed,Object? notes = freezed,Object? blueScore = freezed,Object? redScore = freezed,Object? startedAtTimestamp = freezed,Object? completedAtTimestamp = freezed,Object? syncVersion = null,Object? isDeleted = null,Object? deletedAtTimestamp = freezed,Object? globalMatchDisplayNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bracketId: null == bracketId ? _self.bracketId : bracketId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,matchNumberInRound: null == matchNumberInRound ? _self.matchNumberInRound : matchNumberInRound // ignore: cast_nullable_to_non_nullable
as int,createdAtTimestamp: null == createdAtTimestamp ? _self.createdAtTimestamp : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtTimestamp: null == updatedAtTimestamp ? _self.updatedAtTimestamp : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,participantRedId: freezed == participantRedId ? _self.participantRedId : participantRedId // ignore: cast_nullable_to_non_nullable
as String?,participantBlueId: freezed == participantBlueId ? _self.participantBlueId : participantBlueId // ignore: cast_nullable_to_non_nullable
as String?,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,winnerAdvancesToMatchId: freezed == winnerAdvancesToMatchId ? _self.winnerAdvancesToMatchId : winnerAdvancesToMatchId // ignore: cast_nullable_to_non_nullable
as String?,loserAdvancesToMatchId: freezed == loserAdvancesToMatchId ? _self.loserAdvancesToMatchId : loserAdvancesToMatchId // ignore: cast_nullable_to_non_nullable
as String?,scheduledRingNumber: freezed == scheduledRingNumber ? _self.scheduledRingNumber : scheduledRingNumber // ignore: cast_nullable_to_non_nullable
as int?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MatchStatus,resultType: freezed == resultType ? _self.resultType : resultType // ignore: cast_nullable_to_non_nullable
as MatchResultType?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,blueScore: freezed == blueScore ? _self.blueScore : blueScore // ignore: cast_nullable_to_non_nullable
as int?,redScore: freezed == redScore ? _self.redScore : redScore // ignore: cast_nullable_to_non_nullable
as int?,startedAtTimestamp: freezed == startedAtTimestamp ? _self.startedAtTimestamp : startedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtTimestamp: freezed == completedAtTimestamp ? _self.completedAtTimestamp : completedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,syncVersion: null == syncVersion ? _self.syncVersion : syncVersion // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,deletedAtTimestamp: freezed == deletedAtTimestamp ? _self.deletedAtTimestamp : deletedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,globalMatchDisplayNumber: freezed == globalMatchDisplayNumber ? _self.globalMatchDisplayNumber : globalMatchDisplayNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchEntity].
extension MatchEntityPatterns on MatchEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchEntity value)  $default,){
final _that = this;
switch (_that) {
case _MatchEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MatchEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bracketId,  int roundNumber,  int matchNumberInRound,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? participantRedId,  String? participantBlueId,  String? winnerId,  String? winnerAdvancesToMatchId,  String? loserAdvancesToMatchId,  int? scheduledRingNumber,  DateTime? scheduledTime,  MatchStatus status,  MatchResultType? resultType,  String? notes,  int? blueScore,  int? redScore,  DateTime? startedAtTimestamp,  DateTime? completedAtTimestamp,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  int? globalMatchDisplayNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchEntity() when $default != null:
return $default(_that.id,_that.bracketId,_that.roundNumber,_that.matchNumberInRound,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.participantRedId,_that.participantBlueId,_that.winnerId,_that.winnerAdvancesToMatchId,_that.loserAdvancesToMatchId,_that.scheduledRingNumber,_that.scheduledTime,_that.status,_that.resultType,_that.notes,_that.blueScore,_that.redScore,_that.startedAtTimestamp,_that.completedAtTimestamp,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.globalMatchDisplayNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bracketId,  int roundNumber,  int matchNumberInRound,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? participantRedId,  String? participantBlueId,  String? winnerId,  String? winnerAdvancesToMatchId,  String? loserAdvancesToMatchId,  int? scheduledRingNumber,  DateTime? scheduledTime,  MatchStatus status,  MatchResultType? resultType,  String? notes,  int? blueScore,  int? redScore,  DateTime? startedAtTimestamp,  DateTime? completedAtTimestamp,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  int? globalMatchDisplayNumber)  $default,) {final _that = this;
switch (_that) {
case _MatchEntity():
return $default(_that.id,_that.bracketId,_that.roundNumber,_that.matchNumberInRound,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.participantRedId,_that.participantBlueId,_that.winnerId,_that.winnerAdvancesToMatchId,_that.loserAdvancesToMatchId,_that.scheduledRingNumber,_that.scheduledTime,_that.status,_that.resultType,_that.notes,_that.blueScore,_that.redScore,_that.startedAtTimestamp,_that.completedAtTimestamp,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.globalMatchDisplayNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bracketId,  int roundNumber,  int matchNumberInRound,  DateTime createdAtTimestamp,  DateTime updatedAtTimestamp,  String? participantRedId,  String? participantBlueId,  String? winnerId,  String? winnerAdvancesToMatchId,  String? loserAdvancesToMatchId,  int? scheduledRingNumber,  DateTime? scheduledTime,  MatchStatus status,  MatchResultType? resultType,  String? notes,  int? blueScore,  int? redScore,  DateTime? startedAtTimestamp,  DateTime? completedAtTimestamp,  int syncVersion,  bool isDeleted,  DateTime? deletedAtTimestamp,  int? globalMatchDisplayNumber)?  $default,) {final _that = this;
switch (_that) {
case _MatchEntity() when $default != null:
return $default(_that.id,_that.bracketId,_that.roundNumber,_that.matchNumberInRound,_that.createdAtTimestamp,_that.updatedAtTimestamp,_that.participantRedId,_that.participantBlueId,_that.winnerId,_that.winnerAdvancesToMatchId,_that.loserAdvancesToMatchId,_that.scheduledRingNumber,_that.scheduledTime,_that.status,_that.resultType,_that.notes,_that.blueScore,_that.redScore,_that.startedAtTimestamp,_that.completedAtTimestamp,_that.syncVersion,_that.isDeleted,_that.deletedAtTimestamp,_that.globalMatchDisplayNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchEntity extends MatchEntity {
  const _MatchEntity({required this.id, required this.bracketId, required this.roundNumber, required this.matchNumberInRound, required this.createdAtTimestamp, required this.updatedAtTimestamp, this.participantRedId, this.participantBlueId, this.winnerId, this.winnerAdvancesToMatchId, this.loserAdvancesToMatchId, this.scheduledRingNumber, this.scheduledTime, this.status = MatchStatus.pending, this.resultType, this.notes, this.blueScore, this.redScore, this.startedAtTimestamp, this.completedAtTimestamp, this.syncVersion = 1, this.isDeleted = false, this.deletedAtTimestamp, this.globalMatchDisplayNumber}): super._();
  factory _MatchEntity.fromJson(Map<String, dynamic> json) => _$MatchEntityFromJson(json);

/// Unique identifier for this match (UUID v4).
@override final  String id;
/// The bracket this match belongs to.
@override final  String bracketId;
/// 1-based round number within the bracket.
@override final  int roundNumber;
/// 1-based position of this match within its round.
@override final  int matchNumberInRound;
/// Timestamp when the match record was created.
@override final  DateTime createdAtTimestamp;
/// Timestamp of the most recent update.
@override final  DateTime updatedAtTimestamp;
/// ID of the participant in the red corner (null if unassigned / BYE).
@override final  String? participantRedId;
/// ID of the participant in the blue corner (null if unassigned / BYE).
@override final  String? participantBlueId;
/// ID of the victorious participant (null until result is recorded).
@override final  String? winnerId;
/// Match ID to which the winner advances (null for final match).
@override final  String? winnerAdvancesToMatchId;
/// Match ID to which the loser drops (only in double-elimination).
@override final  String? loserAdvancesToMatchId;
/// Assigned ring / mat number for the match.
@override final  int? scheduledRingNumber;
/// Scheduled start time.
@override final  DateTime? scheduledTime;
/// Current lifecycle status of the match.
@override@JsonKey() final  MatchStatus status;
/// How the match was decided (null if not yet completed).
@override final  MatchResultType? resultType;
/// Free-form notes attached to the match.
@override final  String? notes;
/// Score awarded to the blue-corner participant.
@override final  int? blueScore;
/// Score awarded to the red-corner participant.
@override final  int? redScore;
/// Timestamp when the match started.
@override final  DateTime? startedAtTimestamp;
/// Timestamp when the match was completed.
@override final  DateTime? completedAtTimestamp;
/// Optimistic concurrency version counter.
@override@JsonKey() final  int syncVersion;
/// Soft-delete flag.
@override@JsonKey() final  bool isDeleted;
/// Timestamp of soft deletion, if applicable.
@override final  DateTime? deletedAtTimestamp;
/// Global display sequential number assigned across the entire Tie Sheet.
/// Computed once during bracket creation phase to preserve chronological integrity.
/// Example: 34 translates to "Match #34" in the Canvas UI.
@override final  int? globalMatchDisplayNumber;

/// Create a copy of MatchEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchEntityCopyWith<_MatchEntity> get copyWith => __$MatchEntityCopyWithImpl<_MatchEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bracketId, bracketId) || other.bracketId == bracketId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.matchNumberInRound, matchNumberInRound) || other.matchNumberInRound == matchNumberInRound)&&(identical(other.createdAtTimestamp, createdAtTimestamp) || other.createdAtTimestamp == createdAtTimestamp)&&(identical(other.updatedAtTimestamp, updatedAtTimestamp) || other.updatedAtTimestamp == updatedAtTimestamp)&&(identical(other.participantRedId, participantRedId) || other.participantRedId == participantRedId)&&(identical(other.participantBlueId, participantBlueId) || other.participantBlueId == participantBlueId)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.winnerAdvancesToMatchId, winnerAdvancesToMatchId) || other.winnerAdvancesToMatchId == winnerAdvancesToMatchId)&&(identical(other.loserAdvancesToMatchId, loserAdvancesToMatchId) || other.loserAdvancesToMatchId == loserAdvancesToMatchId)&&(identical(other.scheduledRingNumber, scheduledRingNumber) || other.scheduledRingNumber == scheduledRingNumber)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.resultType, resultType) || other.resultType == resultType)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.blueScore, blueScore) || other.blueScore == blueScore)&&(identical(other.redScore, redScore) || other.redScore == redScore)&&(identical(other.startedAtTimestamp, startedAtTimestamp) || other.startedAtTimestamp == startedAtTimestamp)&&(identical(other.completedAtTimestamp, completedAtTimestamp) || other.completedAtTimestamp == completedAtTimestamp)&&(identical(other.syncVersion, syncVersion) || other.syncVersion == syncVersion)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAtTimestamp, deletedAtTimestamp) || other.deletedAtTimestamp == deletedAtTimestamp)&&(identical(other.globalMatchDisplayNumber, globalMatchDisplayNumber) || other.globalMatchDisplayNumber == globalMatchDisplayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,bracketId,roundNumber,matchNumberInRound,createdAtTimestamp,updatedAtTimestamp,participantRedId,participantBlueId,winnerId,winnerAdvancesToMatchId,loserAdvancesToMatchId,scheduledRingNumber,scheduledTime,status,resultType,notes,blueScore,redScore,startedAtTimestamp,completedAtTimestamp,syncVersion,isDeleted,deletedAtTimestamp,globalMatchDisplayNumber]);

@override
String toString() {
  return 'MatchEntity(id: $id, bracketId: $bracketId, roundNumber: $roundNumber, matchNumberInRound: $matchNumberInRound, createdAtTimestamp: $createdAtTimestamp, updatedAtTimestamp: $updatedAtTimestamp, participantRedId: $participantRedId, participantBlueId: $participantBlueId, winnerId: $winnerId, winnerAdvancesToMatchId: $winnerAdvancesToMatchId, loserAdvancesToMatchId: $loserAdvancesToMatchId, scheduledRingNumber: $scheduledRingNumber, scheduledTime: $scheduledTime, status: $status, resultType: $resultType, notes: $notes, blueScore: $blueScore, redScore: $redScore, startedAtTimestamp: $startedAtTimestamp, completedAtTimestamp: $completedAtTimestamp, syncVersion: $syncVersion, isDeleted: $isDeleted, deletedAtTimestamp: $deletedAtTimestamp, globalMatchDisplayNumber: $globalMatchDisplayNumber)';
}


}

/// @nodoc
abstract mixin class _$MatchEntityCopyWith<$Res> implements $MatchEntityCopyWith<$Res> {
  factory _$MatchEntityCopyWith(_MatchEntity value, $Res Function(_MatchEntity) _then) = __$MatchEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bracketId, int roundNumber, int matchNumberInRound, DateTime createdAtTimestamp, DateTime updatedAtTimestamp, String? participantRedId, String? participantBlueId, String? winnerId, String? winnerAdvancesToMatchId, String? loserAdvancesToMatchId, int? scheduledRingNumber, DateTime? scheduledTime, MatchStatus status, MatchResultType? resultType, String? notes, int? blueScore, int? redScore, DateTime? startedAtTimestamp, DateTime? completedAtTimestamp, int syncVersion, bool isDeleted, DateTime? deletedAtTimestamp, int? globalMatchDisplayNumber
});




}
/// @nodoc
class __$MatchEntityCopyWithImpl<$Res>
    implements _$MatchEntityCopyWith<$Res> {
  __$MatchEntityCopyWithImpl(this._self, this._then);

  final _MatchEntity _self;
  final $Res Function(_MatchEntity) _then;

/// Create a copy of MatchEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bracketId = null,Object? roundNumber = null,Object? matchNumberInRound = null,Object? createdAtTimestamp = null,Object? updatedAtTimestamp = null,Object? participantRedId = freezed,Object? participantBlueId = freezed,Object? winnerId = freezed,Object? winnerAdvancesToMatchId = freezed,Object? loserAdvancesToMatchId = freezed,Object? scheduledRingNumber = freezed,Object? scheduledTime = freezed,Object? status = null,Object? resultType = freezed,Object? notes = freezed,Object? blueScore = freezed,Object? redScore = freezed,Object? startedAtTimestamp = freezed,Object? completedAtTimestamp = freezed,Object? syncVersion = null,Object? isDeleted = null,Object? deletedAtTimestamp = freezed,Object? globalMatchDisplayNumber = freezed,}) {
  return _then(_MatchEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bracketId: null == bracketId ? _self.bracketId : bracketId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,matchNumberInRound: null == matchNumberInRound ? _self.matchNumberInRound : matchNumberInRound // ignore: cast_nullable_to_non_nullable
as int,createdAtTimestamp: null == createdAtTimestamp ? _self.createdAtTimestamp : createdAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtTimestamp: null == updatedAtTimestamp ? _self.updatedAtTimestamp : updatedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,participantRedId: freezed == participantRedId ? _self.participantRedId : participantRedId // ignore: cast_nullable_to_non_nullable
as String?,participantBlueId: freezed == participantBlueId ? _self.participantBlueId : participantBlueId // ignore: cast_nullable_to_non_nullable
as String?,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,winnerAdvancesToMatchId: freezed == winnerAdvancesToMatchId ? _self.winnerAdvancesToMatchId : winnerAdvancesToMatchId // ignore: cast_nullable_to_non_nullable
as String?,loserAdvancesToMatchId: freezed == loserAdvancesToMatchId ? _self.loserAdvancesToMatchId : loserAdvancesToMatchId // ignore: cast_nullable_to_non_nullable
as String?,scheduledRingNumber: freezed == scheduledRingNumber ? _self.scheduledRingNumber : scheduledRingNumber // ignore: cast_nullable_to_non_nullable
as int?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MatchStatus,resultType: freezed == resultType ? _self.resultType : resultType // ignore: cast_nullable_to_non_nullable
as MatchResultType?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,blueScore: freezed == blueScore ? _self.blueScore : blueScore // ignore: cast_nullable_to_non_nullable
as int?,redScore: freezed == redScore ? _self.redScore : redScore // ignore: cast_nullable_to_non_nullable
as int?,startedAtTimestamp: freezed == startedAtTimestamp ? _self.startedAtTimestamp : startedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtTimestamp: freezed == completedAtTimestamp ? _self.completedAtTimestamp : completedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,syncVersion: null == syncVersion ? _self.syncVersion : syncVersion // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,deletedAtTimestamp: freezed == deletedAtTimestamp ? _self.deletedAtTimestamp : deletedAtTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,globalMatchDisplayNumber: freezed == globalMatchDisplayNumber ? _self.globalMatchDisplayNumber : globalMatchDisplayNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
