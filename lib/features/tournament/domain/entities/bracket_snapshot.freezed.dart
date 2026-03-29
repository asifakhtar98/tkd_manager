// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketSnapshot {

/// Unique ID for this snapshot (UUID v4).
 String get id;/// Foreign key to 'auth.users'. The owner of the tournament snapshot.
 String get userId;/// Foreign key to 'tournaments'. Which tournament this bracket belongs to.
 String get tournamentId;/// Display label, e.g. "Single Elim — 8 Players".
 String get label;/// The elimination format used for this bracket generation.
 BracketFormat get format; int get participantCount; bool get includeThirdPlaceMatch; bool get dojangSeparation;/// Bracket-level classification labels displayed in the tie sheet header.
 BracketClassification get classification;/// Wall-clock time when the bracket was generated.
 DateTime get generatedAt;/// Full participant list at the time of generation.
 List<ParticipantEntity> get participants;/// The generated bracket data (single or double elimination union).
 BracketResult get result;/// Last update timestamp.
 DateTime get updatedAt;/// Persisted undo/redo history entries.
///
/// Stored as JSONB in the `action_history` column so the full undo/redo
/// stack survives page navigation and browser reloads.
 List<BracketHistoryEntry> get actionHistory;
/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketSnapshotCopyWith<BracketSnapshot> get copyWith => _$BracketSnapshotCopyWithImpl<BracketSnapshot>(this as BracketSnapshot, _$identity);

  /// Serializes this BracketSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.label, label) || other.label == label)&&(identical(other.format, format) || other.format == format)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.dojangSeparation, dojangSeparation) || other.dojangSeparation == dojangSeparation)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.result, result) || other.result == result)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.actionHistory, actionHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,tournamentId,label,format,participantCount,includeThirdPlaceMatch,dojangSeparation,classification,generatedAt,const DeepCollectionEquality().hash(participants),result,updatedAt,const DeepCollectionEquality().hash(actionHistory));

@override
String toString() {
  return 'BracketSnapshot(id: $id, userId: $userId, tournamentId: $tournamentId, label: $label, format: $format, participantCount: $participantCount, includeThirdPlaceMatch: $includeThirdPlaceMatch, dojangSeparation: $dojangSeparation, classification: $classification, generatedAt: $generatedAt, participants: $participants, result: $result, updatedAt: $updatedAt, actionHistory: $actionHistory)';
}


}

/// @nodoc
abstract mixin class $BracketSnapshotCopyWith<$Res>  {
  factory $BracketSnapshotCopyWith(BracketSnapshot value, $Res Function(BracketSnapshot) _then) = _$BracketSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String tournamentId, String label, BracketFormat format, int participantCount, bool includeThirdPlaceMatch, bool dojangSeparation, BracketClassification classification, DateTime generatedAt, List<ParticipantEntity> participants, BracketResult result, DateTime updatedAt, List<BracketHistoryEntry> actionHistory
});


$BracketClassificationCopyWith<$Res> get classification;$BracketResultCopyWith<$Res> get result;

}
/// @nodoc
class _$BracketSnapshotCopyWithImpl<$Res>
    implements $BracketSnapshotCopyWith<$Res> {
  _$BracketSnapshotCopyWithImpl(this._self, this._then);

  final BracketSnapshot _self;
  final $Res Function(BracketSnapshot) _then;

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? tournamentId = null,Object? label = null,Object? format = null,Object? participantCount = null,Object? includeThirdPlaceMatch = null,Object? dojangSeparation = null,Object? classification = null,Object? generatedAt = null,Object? participants = null,Object? result = null,Object? updatedAt = null,Object? actionHistory = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,dojangSeparation: null == dojangSeparation ? _self.dojangSeparation : dojangSeparation // ignore: cast_nullable_to_non_nullable
as bool,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as BracketClassification,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,actionHistory: null == actionHistory ? _self.actionHistory : actionHistory // ignore: cast_nullable_to_non_nullable
as List<BracketHistoryEntry>,
  ));
}
/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketClassificationCopyWith<$Res> get classification {
  
  return $BracketClassificationCopyWith<$Res>(_self.classification, (value) {
    return _then(_self.copyWith(classification: value));
  });
}/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get result {
  
  return $BracketResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketSnapshot].
extension BracketSnapshotPatterns on BracketSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BracketSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String tournamentId,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  BracketClassification classification,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result,  DateTime updatedAt,  List<BracketHistoryEntry> actionHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
return $default(_that.id,_that.userId,_that.tournamentId,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.classification,_that.generatedAt,_that.participants,_that.result,_that.updatedAt,_that.actionHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String tournamentId,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  BracketClassification classification,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result,  DateTime updatedAt,  List<BracketHistoryEntry> actionHistory)  $default,) {final _that = this;
switch (_that) {
case _BracketSnapshot():
return $default(_that.id,_that.userId,_that.tournamentId,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.classification,_that.generatedAt,_that.participants,_that.result,_that.updatedAt,_that.actionHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String tournamentId,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  BracketClassification classification,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result,  DateTime updatedAt,  List<BracketHistoryEntry> actionHistory)?  $default,) {final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
return $default(_that.id,_that.userId,_that.tournamentId,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.classification,_that.generatedAt,_that.participants,_that.result,_that.updatedAt,_that.actionHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BracketSnapshot implements BracketSnapshot {
  const _BracketSnapshot({required this.id, required this.userId, required this.tournamentId, required this.label, required this.format, required this.participantCount, required this.includeThirdPlaceMatch, required this.dojangSeparation, this.classification = const BracketClassification(), required this.generatedAt, required final  List<ParticipantEntity> participants, required this.result, required this.updatedAt, final  List<BracketHistoryEntry> actionHistory = const []}): _participants = participants,_actionHistory = actionHistory;
  factory _BracketSnapshot.fromJson(Map<String, dynamic> json) => _$BracketSnapshotFromJson(json);

/// Unique ID for this snapshot (UUID v4).
@override final  String id;
/// Foreign key to 'auth.users'. The owner of the tournament snapshot.
@override final  String userId;
/// Foreign key to 'tournaments'. Which tournament this bracket belongs to.
@override final  String tournamentId;
/// Display label, e.g. "Single Elim — 8 Players".
@override final  String label;
/// The elimination format used for this bracket generation.
@override final  BracketFormat format;
@override final  int participantCount;
@override final  bool includeThirdPlaceMatch;
@override final  bool dojangSeparation;
/// Bracket-level classification labels displayed in the tie sheet header.
@override@JsonKey() final  BracketClassification classification;
/// Wall-clock time when the bracket was generated.
@override final  DateTime generatedAt;
/// Full participant list at the time of generation.
 final  List<ParticipantEntity> _participants;
/// Full participant list at the time of generation.
@override List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The generated bracket data (single or double elimination union).
@override final  BracketResult result;
/// Last update timestamp.
@override final  DateTime updatedAt;
/// Persisted undo/redo history entries.
///
/// Stored as JSONB in the `action_history` column so the full undo/redo
/// stack survives page navigation and browser reloads.
 final  List<BracketHistoryEntry> _actionHistory;
/// Persisted undo/redo history entries.
///
/// Stored as JSONB in the `action_history` column so the full undo/redo
/// stack survives page navigation and browser reloads.
@override@JsonKey() List<BracketHistoryEntry> get actionHistory {
  if (_actionHistory is EqualUnmodifiableListView) return _actionHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionHistory);
}


/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketSnapshotCopyWith<_BracketSnapshot> get copyWith => __$BracketSnapshotCopyWithImpl<_BracketSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.label, label) || other.label == label)&&(identical(other.format, format) || other.format == format)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.dojangSeparation, dojangSeparation) || other.dojangSeparation == dojangSeparation)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.result, result) || other.result == result)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._actionHistory, _actionHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,tournamentId,label,format,participantCount,includeThirdPlaceMatch,dojangSeparation,classification,generatedAt,const DeepCollectionEquality().hash(_participants),result,updatedAt,const DeepCollectionEquality().hash(_actionHistory));

@override
String toString() {
  return 'BracketSnapshot(id: $id, userId: $userId, tournamentId: $tournamentId, label: $label, format: $format, participantCount: $participantCount, includeThirdPlaceMatch: $includeThirdPlaceMatch, dojangSeparation: $dojangSeparation, classification: $classification, generatedAt: $generatedAt, participants: $participants, result: $result, updatedAt: $updatedAt, actionHistory: $actionHistory)';
}


}

/// @nodoc
abstract mixin class _$BracketSnapshotCopyWith<$Res> implements $BracketSnapshotCopyWith<$Res> {
  factory _$BracketSnapshotCopyWith(_BracketSnapshot value, $Res Function(_BracketSnapshot) _then) = __$BracketSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String tournamentId, String label, BracketFormat format, int participantCount, bool includeThirdPlaceMatch, bool dojangSeparation, BracketClassification classification, DateTime generatedAt, List<ParticipantEntity> participants, BracketResult result, DateTime updatedAt, List<BracketHistoryEntry> actionHistory
});


@override $BracketClassificationCopyWith<$Res> get classification;@override $BracketResultCopyWith<$Res> get result;

}
/// @nodoc
class __$BracketSnapshotCopyWithImpl<$Res>
    implements _$BracketSnapshotCopyWith<$Res> {
  __$BracketSnapshotCopyWithImpl(this._self, this._then);

  final _BracketSnapshot _self;
  final $Res Function(_BracketSnapshot) _then;

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? tournamentId = null,Object? label = null,Object? format = null,Object? participantCount = null,Object? includeThirdPlaceMatch = null,Object? dojangSeparation = null,Object? classification = null,Object? generatedAt = null,Object? participants = null,Object? result = null,Object? updatedAt = null,Object? actionHistory = null,}) {
  return _then(_BracketSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,dojangSeparation: null == dojangSeparation ? _self.dojangSeparation : dojangSeparation // ignore: cast_nullable_to_non_nullable
as bool,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as BracketClassification,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,actionHistory: null == actionHistory ? _self._actionHistory : actionHistory // ignore: cast_nullable_to_non_nullable
as List<BracketHistoryEntry>,
  ));
}

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketClassificationCopyWith<$Res> get classification {
  
  return $BracketClassificationCopyWith<$Res>(_self.classification, (value) {
    return _then(_self.copyWith(classification: value));
  });
}/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get result {
  
  return $BracketResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
