// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_match_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketMatchAction {

/// The match that was scored.
 String get matchId;/// The participant who was declared the winner.
 String get winnerId;/// How the match was decided (points, KO, etc.).
 MatchResultType get resultType;/// Optional blue-corner score.
 int? get blueScore;/// Optional red-corner score.
 int? get redScore;/// When this action was recorded.
 DateTime get recordedAt;/// Human-readable label for the history panel,
/// e.g. "R1-M2: John Doe won by Points (3-1)".
 String get displayLabel;
/// Create a copy of BracketMatchAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketMatchActionCopyWith<BracketMatchAction> get copyWith => _$BracketMatchActionCopyWithImpl<BracketMatchAction>(this as BracketMatchAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketMatchAction&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.resultType, resultType) || other.resultType == resultType)&&(identical(other.blueScore, blueScore) || other.blueScore == blueScore)&&(identical(other.redScore, redScore) || other.redScore == redScore)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel));
}


@override
int get hashCode => Object.hash(runtimeType,matchId,winnerId,resultType,blueScore,redScore,recordedAt,displayLabel);

@override
String toString() {
  return 'BracketMatchAction(matchId: $matchId, winnerId: $winnerId, resultType: $resultType, blueScore: $blueScore, redScore: $redScore, recordedAt: $recordedAt, displayLabel: $displayLabel)';
}


}

/// @nodoc
abstract mixin class $BracketMatchActionCopyWith<$Res>  {
  factory $BracketMatchActionCopyWith(BracketMatchAction value, $Res Function(BracketMatchAction) _then) = _$BracketMatchActionCopyWithImpl;
@useResult
$Res call({
 String matchId, String winnerId, MatchResultType resultType, int? blueScore, int? redScore, DateTime recordedAt, String displayLabel
});




}
/// @nodoc
class _$BracketMatchActionCopyWithImpl<$Res>
    implements $BracketMatchActionCopyWith<$Res> {
  _$BracketMatchActionCopyWithImpl(this._self, this._then);

  final BracketMatchAction _self;
  final $Res Function(BracketMatchAction) _then;

/// Create a copy of BracketMatchAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? winnerId = null,Object? resultType = null,Object? blueScore = freezed,Object? redScore = freezed,Object? recordedAt = null,Object? displayLabel = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,resultType: null == resultType ? _self.resultType : resultType // ignore: cast_nullable_to_non_nullable
as MatchResultType,blueScore: freezed == blueScore ? _self.blueScore : blueScore // ignore: cast_nullable_to_non_nullable
as int?,redScore: freezed == redScore ? _self.redScore : redScore // ignore: cast_nullable_to_non_nullable
as int?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketMatchAction].
extension BracketMatchActionPatterns on BracketMatchAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketMatchAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketMatchAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketMatchAction value)  $default,){
final _that = this;
switch (_that) {
case _BracketMatchAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketMatchAction value)?  $default,){
final _that = this;
switch (_that) {
case _BracketMatchAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore,  DateTime recordedAt,  String displayLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketMatchAction() when $default != null:
return $default(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore,_that.recordedAt,_that.displayLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore,  DateTime recordedAt,  String displayLabel)  $default,) {final _that = this;
switch (_that) {
case _BracketMatchAction():
return $default(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore,_that.recordedAt,_that.displayLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore,  DateTime recordedAt,  String displayLabel)?  $default,) {final _that = this;
switch (_that) {
case _BracketMatchAction() when $default != null:
return $default(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore,_that.recordedAt,_that.displayLabel);case _:
  return null;

}
}

}

/// @nodoc


class _BracketMatchAction implements BracketMatchAction {
  const _BracketMatchAction({required this.matchId, required this.winnerId, required this.resultType, this.blueScore, this.redScore, required this.recordedAt, required this.displayLabel});
  

/// The match that was scored.
@override final  String matchId;
/// The participant who was declared the winner.
@override final  String winnerId;
/// How the match was decided (points, KO, etc.).
@override final  MatchResultType resultType;
/// Optional blue-corner score.
@override final  int? blueScore;
/// Optional red-corner score.
@override final  int? redScore;
/// When this action was recorded.
@override final  DateTime recordedAt;
/// Human-readable label for the history panel,
/// e.g. "R1-M2: John Doe won by Points (3-1)".
@override final  String displayLabel;

/// Create a copy of BracketMatchAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketMatchActionCopyWith<_BracketMatchAction> get copyWith => __$BracketMatchActionCopyWithImpl<_BracketMatchAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketMatchAction&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.resultType, resultType) || other.resultType == resultType)&&(identical(other.blueScore, blueScore) || other.blueScore == blueScore)&&(identical(other.redScore, redScore) || other.redScore == redScore)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel));
}


@override
int get hashCode => Object.hash(runtimeType,matchId,winnerId,resultType,blueScore,redScore,recordedAt,displayLabel);

@override
String toString() {
  return 'BracketMatchAction(matchId: $matchId, winnerId: $winnerId, resultType: $resultType, blueScore: $blueScore, redScore: $redScore, recordedAt: $recordedAt, displayLabel: $displayLabel)';
}


}

/// @nodoc
abstract mixin class _$BracketMatchActionCopyWith<$Res> implements $BracketMatchActionCopyWith<$Res> {
  factory _$BracketMatchActionCopyWith(_BracketMatchAction value, $Res Function(_BracketMatchAction) _then) = __$BracketMatchActionCopyWithImpl;
@override @useResult
$Res call({
 String matchId, String winnerId, MatchResultType resultType, int? blueScore, int? redScore, DateTime recordedAt, String displayLabel
});




}
/// @nodoc
class __$BracketMatchActionCopyWithImpl<$Res>
    implements _$BracketMatchActionCopyWith<$Res> {
  __$BracketMatchActionCopyWithImpl(this._self, this._then);

  final _BracketMatchAction _self;
  final $Res Function(_BracketMatchAction) _then;

/// Create a copy of BracketMatchAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? winnerId = null,Object? resultType = null,Object? blueScore = freezed,Object? redScore = freezed,Object? recordedAt = null,Object? displayLabel = null,}) {
  return _then(_BracketMatchAction(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,resultType: null == resultType ? _self.resultType : resultType // ignore: cast_nullable_to_non_nullable
as MatchResultType,blueScore: freezed == blueScore ? _self.blueScore : blueScore // ignore: cast_nullable_to_non_nullable
as int?,redScore: freezed == redScore ? _self.redScore : redScore // ignore: cast_nullable_to_non_nullable
as int?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
