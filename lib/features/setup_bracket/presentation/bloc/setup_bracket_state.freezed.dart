// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_bracket_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetupBracketState {

/// The owning tournament — used as the hydration storage key.
 String get tournamentId;/// The participant roster being built for this bracket.
 List<ParticipantEntity> get participants;/// The elimination format selected for bracket generation.
 BracketFormat get selectedBracketFormat;/// Whether participants from the same dojang/school are auto-separated
/// in the bracket seeding order.
 bool get isDojangSeparationEnabled;/// Whether a 3rd-place bronze medal match is included.
/// Only applies to single-elimination brackets.
 bool get isThirdPlaceMatchIncluded;/// Bracket classification: age category label (e.g. "Junior", "Senior").
 String get bracketAgeCategoryLabel;/// Bracket classification: gender label (e.g. "Male", "Female").
 String get bracketGenderLabel;/// Bracket classification: weight division label (e.g. "-58kg").
 String get bracketWeightDivisionLabel;/// True while waiting for [TournamentBloc] to confirm snapshot persistence.
 bool get isAwaitingBracketGeneration;/// The snapshot ID currently being persisted. Non-null only during the
/// brief window between dispatch and confirmation.
 String? get pendingSnapshotId;
/// Create a copy of SetupBracketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketStateCopyWith<SetupBracketState> get copyWith => _$SetupBracketStateCopyWithImpl<SetupBracketState>(this as SetupBracketState, _$identity);

  /// Serializes this SetupBracketState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketState&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.selectedBracketFormat, selectedBracketFormat) || other.selectedBracketFormat == selectedBracketFormat)&&(identical(other.isDojangSeparationEnabled, isDojangSeparationEnabled) || other.isDojangSeparationEnabled == isDojangSeparationEnabled)&&(identical(other.isThirdPlaceMatchIncluded, isThirdPlaceMatchIncluded) || other.isThirdPlaceMatchIncluded == isThirdPlaceMatchIncluded)&&(identical(other.bracketAgeCategoryLabel, bracketAgeCategoryLabel) || other.bracketAgeCategoryLabel == bracketAgeCategoryLabel)&&(identical(other.bracketGenderLabel, bracketGenderLabel) || other.bracketGenderLabel == bracketGenderLabel)&&(identical(other.bracketWeightDivisionLabel, bracketWeightDivisionLabel) || other.bracketWeightDivisionLabel == bracketWeightDivisionLabel)&&(identical(other.isAwaitingBracketGeneration, isAwaitingBracketGeneration) || other.isAwaitingBracketGeneration == isAwaitingBracketGeneration)&&(identical(other.pendingSnapshotId, pendingSnapshotId) || other.pendingSnapshotId == pendingSnapshotId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,const DeepCollectionEquality().hash(participants),selectedBracketFormat,isDojangSeparationEnabled,isThirdPlaceMatchIncluded,bracketAgeCategoryLabel,bracketGenderLabel,bracketWeightDivisionLabel,isAwaitingBracketGeneration,pendingSnapshotId);

@override
String toString() {
  return 'SetupBracketState(tournamentId: $tournamentId, participants: $participants, selectedBracketFormat: $selectedBracketFormat, isDojangSeparationEnabled: $isDojangSeparationEnabled, isThirdPlaceMatchIncluded: $isThirdPlaceMatchIncluded, bracketAgeCategoryLabel: $bracketAgeCategoryLabel, bracketGenderLabel: $bracketGenderLabel, bracketWeightDivisionLabel: $bracketWeightDivisionLabel, isAwaitingBracketGeneration: $isAwaitingBracketGeneration, pendingSnapshotId: $pendingSnapshotId)';
}


}

/// @nodoc
abstract mixin class $SetupBracketStateCopyWith<$Res>  {
  factory $SetupBracketStateCopyWith(SetupBracketState value, $Res Function(SetupBracketState) _then) = _$SetupBracketStateCopyWithImpl;
@useResult
$Res call({
 String tournamentId, List<ParticipantEntity> participants, BracketFormat selectedBracketFormat, bool isDojangSeparationEnabled, bool isThirdPlaceMatchIncluded, String bracketAgeCategoryLabel, String bracketGenderLabel, String bracketWeightDivisionLabel, bool isAwaitingBracketGeneration, String? pendingSnapshotId
});




}
/// @nodoc
class _$SetupBracketStateCopyWithImpl<$Res>
    implements $SetupBracketStateCopyWith<$Res> {
  _$SetupBracketStateCopyWithImpl(this._self, this._then);

  final SetupBracketState _self;
  final $Res Function(SetupBracketState) _then;

/// Create a copy of SetupBracketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tournamentId = null,Object? participants = null,Object? selectedBracketFormat = null,Object? isDojangSeparationEnabled = null,Object? isThirdPlaceMatchIncluded = null,Object? bracketAgeCategoryLabel = null,Object? bracketGenderLabel = null,Object? bracketWeightDivisionLabel = null,Object? isAwaitingBracketGeneration = null,Object? pendingSnapshotId = freezed,}) {
  return _then(_self.copyWith(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,selectedBracketFormat: null == selectedBracketFormat ? _self.selectedBracketFormat : selectedBracketFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,isDojangSeparationEnabled: null == isDojangSeparationEnabled ? _self.isDojangSeparationEnabled : isDojangSeparationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isThirdPlaceMatchIncluded: null == isThirdPlaceMatchIncluded ? _self.isThirdPlaceMatchIncluded : isThirdPlaceMatchIncluded // ignore: cast_nullable_to_non_nullable
as bool,bracketAgeCategoryLabel: null == bracketAgeCategoryLabel ? _self.bracketAgeCategoryLabel : bracketAgeCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,bracketGenderLabel: null == bracketGenderLabel ? _self.bracketGenderLabel : bracketGenderLabel // ignore: cast_nullable_to_non_nullable
as String,bracketWeightDivisionLabel: null == bracketWeightDivisionLabel ? _self.bracketWeightDivisionLabel : bracketWeightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,isAwaitingBracketGeneration: null == isAwaitingBracketGeneration ? _self.isAwaitingBracketGeneration : isAwaitingBracketGeneration // ignore: cast_nullable_to_non_nullable
as bool,pendingSnapshotId: freezed == pendingSnapshotId ? _self.pendingSnapshotId : pendingSnapshotId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetupBracketState].
extension SetupBracketStatePatterns on SetupBracketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetupBracketState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetupBracketState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetupBracketState value)  $default,){
final _that = this;
switch (_that) {
case _SetupBracketState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetupBracketState value)?  $default,){
final _that = this;
switch (_that) {
case _SetupBracketState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tournamentId,  List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel,  bool isAwaitingBracketGeneration,  String? pendingSnapshotId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetupBracketState() when $default != null:
return $default(_that.tournamentId,_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel,_that.isAwaitingBracketGeneration,_that.pendingSnapshotId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tournamentId,  List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel,  bool isAwaitingBracketGeneration,  String? pendingSnapshotId)  $default,) {final _that = this;
switch (_that) {
case _SetupBracketState():
return $default(_that.tournamentId,_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel,_that.isAwaitingBracketGeneration,_that.pendingSnapshotId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tournamentId,  List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel,  bool isAwaitingBracketGeneration,  String? pendingSnapshotId)?  $default,) {final _that = this;
switch (_that) {
case _SetupBracketState() when $default != null:
return $default(_that.tournamentId,_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel,_that.isAwaitingBracketGeneration,_that.pendingSnapshotId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetupBracketState extends SetupBracketState {
  const _SetupBracketState({required this.tournamentId, final  List<ParticipantEntity> participants = const [], this.selectedBracketFormat = BracketFormat.singleElimination, this.isDojangSeparationEnabled = true, this.isThirdPlaceMatchIncluded = false, this.bracketAgeCategoryLabel = '', this.bracketGenderLabel = '', this.bracketWeightDivisionLabel = '', this.isAwaitingBracketGeneration = false, this.pendingSnapshotId}): _participants = participants,super._();
  factory _SetupBracketState.fromJson(Map<String, dynamic> json) => _$SetupBracketStateFromJson(json);

/// The owning tournament — used as the hydration storage key.
@override final  String tournamentId;
/// The participant roster being built for this bracket.
 final  List<ParticipantEntity> _participants;
/// The participant roster being built for this bracket.
@override@JsonKey() List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The elimination format selected for bracket generation.
@override@JsonKey() final  BracketFormat selectedBracketFormat;
/// Whether participants from the same dojang/school are auto-separated
/// in the bracket seeding order.
@override@JsonKey() final  bool isDojangSeparationEnabled;
/// Whether a 3rd-place bronze medal match is included.
/// Only applies to single-elimination brackets.
@override@JsonKey() final  bool isThirdPlaceMatchIncluded;
/// Bracket classification: age category label (e.g. "Junior", "Senior").
@override@JsonKey() final  String bracketAgeCategoryLabel;
/// Bracket classification: gender label (e.g. "Male", "Female").
@override@JsonKey() final  String bracketGenderLabel;
/// Bracket classification: weight division label (e.g. "-58kg").
@override@JsonKey() final  String bracketWeightDivisionLabel;
/// True while waiting for [TournamentBloc] to confirm snapshot persistence.
@override@JsonKey() final  bool isAwaitingBracketGeneration;
/// The snapshot ID currently being persisted. Non-null only during the
/// brief window between dispatch and confirmation.
@override final  String? pendingSnapshotId;

/// Create a copy of SetupBracketState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetupBracketStateCopyWith<_SetupBracketState> get copyWith => __$SetupBracketStateCopyWithImpl<_SetupBracketState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetupBracketStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetupBracketState&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.selectedBracketFormat, selectedBracketFormat) || other.selectedBracketFormat == selectedBracketFormat)&&(identical(other.isDojangSeparationEnabled, isDojangSeparationEnabled) || other.isDojangSeparationEnabled == isDojangSeparationEnabled)&&(identical(other.isThirdPlaceMatchIncluded, isThirdPlaceMatchIncluded) || other.isThirdPlaceMatchIncluded == isThirdPlaceMatchIncluded)&&(identical(other.bracketAgeCategoryLabel, bracketAgeCategoryLabel) || other.bracketAgeCategoryLabel == bracketAgeCategoryLabel)&&(identical(other.bracketGenderLabel, bracketGenderLabel) || other.bracketGenderLabel == bracketGenderLabel)&&(identical(other.bracketWeightDivisionLabel, bracketWeightDivisionLabel) || other.bracketWeightDivisionLabel == bracketWeightDivisionLabel)&&(identical(other.isAwaitingBracketGeneration, isAwaitingBracketGeneration) || other.isAwaitingBracketGeneration == isAwaitingBracketGeneration)&&(identical(other.pendingSnapshotId, pendingSnapshotId) || other.pendingSnapshotId == pendingSnapshotId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,const DeepCollectionEquality().hash(_participants),selectedBracketFormat,isDojangSeparationEnabled,isThirdPlaceMatchIncluded,bracketAgeCategoryLabel,bracketGenderLabel,bracketWeightDivisionLabel,isAwaitingBracketGeneration,pendingSnapshotId);

@override
String toString() {
  return 'SetupBracketState(tournamentId: $tournamentId, participants: $participants, selectedBracketFormat: $selectedBracketFormat, isDojangSeparationEnabled: $isDojangSeparationEnabled, isThirdPlaceMatchIncluded: $isThirdPlaceMatchIncluded, bracketAgeCategoryLabel: $bracketAgeCategoryLabel, bracketGenderLabel: $bracketGenderLabel, bracketWeightDivisionLabel: $bracketWeightDivisionLabel, isAwaitingBracketGeneration: $isAwaitingBracketGeneration, pendingSnapshotId: $pendingSnapshotId)';
}


}

/// @nodoc
abstract mixin class _$SetupBracketStateCopyWith<$Res> implements $SetupBracketStateCopyWith<$Res> {
  factory _$SetupBracketStateCopyWith(_SetupBracketState value, $Res Function(_SetupBracketState) _then) = __$SetupBracketStateCopyWithImpl;
@override @useResult
$Res call({
 String tournamentId, List<ParticipantEntity> participants, BracketFormat selectedBracketFormat, bool isDojangSeparationEnabled, bool isThirdPlaceMatchIncluded, String bracketAgeCategoryLabel, String bracketGenderLabel, String bracketWeightDivisionLabel, bool isAwaitingBracketGeneration, String? pendingSnapshotId
});




}
/// @nodoc
class __$SetupBracketStateCopyWithImpl<$Res>
    implements _$SetupBracketStateCopyWith<$Res> {
  __$SetupBracketStateCopyWithImpl(this._self, this._then);

  final _SetupBracketState _self;
  final $Res Function(_SetupBracketState) _then;

/// Create a copy of SetupBracketState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? participants = null,Object? selectedBracketFormat = null,Object? isDojangSeparationEnabled = null,Object? isThirdPlaceMatchIncluded = null,Object? bracketAgeCategoryLabel = null,Object? bracketGenderLabel = null,Object? bracketWeightDivisionLabel = null,Object? isAwaitingBracketGeneration = null,Object? pendingSnapshotId = freezed,}) {
  return _then(_SetupBracketState(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,selectedBracketFormat: null == selectedBracketFormat ? _self.selectedBracketFormat : selectedBracketFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,isDojangSeparationEnabled: null == isDojangSeparationEnabled ? _self.isDojangSeparationEnabled : isDojangSeparationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isThirdPlaceMatchIncluded: null == isThirdPlaceMatchIncluded ? _self.isThirdPlaceMatchIncluded : isThirdPlaceMatchIncluded // ignore: cast_nullable_to_non_nullable
as bool,bracketAgeCategoryLabel: null == bracketAgeCategoryLabel ? _self.bracketAgeCategoryLabel : bracketAgeCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,bracketGenderLabel: null == bracketGenderLabel ? _self.bracketGenderLabel : bracketGenderLabel // ignore: cast_nullable_to_non_nullable
as String,bracketWeightDivisionLabel: null == bracketWeightDivisionLabel ? _self.bracketWeightDivisionLabel : bracketWeightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,isAwaitingBracketGeneration: null == isAwaitingBracketGeneration ? _self.isAwaitingBracketGeneration : isAwaitingBracketGeneration // ignore: cast_nullable_to_non_nullable
as bool,pendingSnapshotId: freezed == pendingSnapshotId ? _self.pendingSnapshotId : pendingSnapshotId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
