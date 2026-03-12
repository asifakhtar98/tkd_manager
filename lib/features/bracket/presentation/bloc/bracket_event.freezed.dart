// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketEvent()';
}


}

/// @nodoc
class $BracketEventCopyWith<$Res>  {
$BracketEventCopyWith(BracketEvent _, $Res Function(BracketEvent) __);
}


/// Adds pattern-matching-related methods to [BracketEvent].
extension BracketEventPatterns on BracketEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketGenerateRequested value)?  generateRequested,TResult Function( BracketRegenerateRequested value)?  regenerateRequested,TResult Function( BracketMatchResultRecorded value)?  matchResultRecorded,TResult Function( BracketErrorDismissed value)?  errorDismissed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketGenerateRequested() when generateRequested != null:
return generateRequested(_that);case BracketRegenerateRequested() when regenerateRequested != null:
return regenerateRequested(_that);case BracketMatchResultRecorded() when matchResultRecorded != null:
return matchResultRecorded(_that);case BracketErrorDismissed() when errorDismissed != null:
return errorDismissed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketGenerateRequested value)  generateRequested,required TResult Function( BracketRegenerateRequested value)  regenerateRequested,required TResult Function( BracketMatchResultRecorded value)  matchResultRecorded,required TResult Function( BracketErrorDismissed value)  errorDismissed,}){
final _that = this;
switch (_that) {
case BracketGenerateRequested():
return generateRequested(_that);case BracketRegenerateRequested():
return regenerateRequested(_that);case BracketMatchResultRecorded():
return matchResultRecorded(_that);case BracketErrorDismissed():
return errorDismissed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketGenerateRequested value)?  generateRequested,TResult? Function( BracketRegenerateRequested value)?  regenerateRequested,TResult? Function( BracketMatchResultRecorded value)?  matchResultRecorded,TResult? Function( BracketErrorDismissed value)?  errorDismissed,}){
final _that = this;
switch (_that) {
case BracketGenerateRequested() when generateRequested != null:
return generateRequested(_that);case BracketRegenerateRequested() when regenerateRequested != null:
return regenerateRequested(_that);case BracketMatchResultRecorded() when matchResultRecorded != null:
return matchResultRecorded(_that);case BracketErrorDismissed() when errorDismissed != null:
return errorDismissed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<ParticipantEntity> participants,  BracketFormat bracketFormat,  bool dojangSeparation,  bool includeThirdPlaceMatch)?  generateRequested,TResult Function()?  regenerateRequested,TResult Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore)?  matchResultRecorded,TResult Function()?  errorDismissed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketGenerateRequested() when generateRequested != null:
return generateRequested(_that.participants,_that.bracketFormat,_that.dojangSeparation,_that.includeThirdPlaceMatch);case BracketRegenerateRequested() when regenerateRequested != null:
return regenerateRequested();case BracketMatchResultRecorded() when matchResultRecorded != null:
return matchResultRecorded(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore);case BracketErrorDismissed() when errorDismissed != null:
return errorDismissed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<ParticipantEntity> participants,  BracketFormat bracketFormat,  bool dojangSeparation,  bool includeThirdPlaceMatch)  generateRequested,required TResult Function()  regenerateRequested,required TResult Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore)  matchResultRecorded,required TResult Function()  errorDismissed,}) {final _that = this;
switch (_that) {
case BracketGenerateRequested():
return generateRequested(_that.participants,_that.bracketFormat,_that.dojangSeparation,_that.includeThirdPlaceMatch);case BracketRegenerateRequested():
return regenerateRequested();case BracketMatchResultRecorded():
return matchResultRecorded(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore);case BracketErrorDismissed():
return errorDismissed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<ParticipantEntity> participants,  BracketFormat bracketFormat,  bool dojangSeparation,  bool includeThirdPlaceMatch)?  generateRequested,TResult? Function()?  regenerateRequested,TResult? Function( String matchId,  String winnerId,  MatchResultType resultType,  int? blueScore,  int? redScore)?  matchResultRecorded,TResult? Function()?  errorDismissed,}) {final _that = this;
switch (_that) {
case BracketGenerateRequested() when generateRequested != null:
return generateRequested(_that.participants,_that.bracketFormat,_that.dojangSeparation,_that.includeThirdPlaceMatch);case BracketRegenerateRequested() when regenerateRequested != null:
return regenerateRequested();case BracketMatchResultRecorded() when matchResultRecorded != null:
return matchResultRecorded(_that.matchId,_that.winnerId,_that.resultType,_that.blueScore,_that.redScore);case BracketErrorDismissed() when errorDismissed != null:
return errorDismissed();case _:
  return null;

}
}

}

/// @nodoc


class BracketGenerateRequested implements BracketEvent {
  const BracketGenerateRequested({required final  List<ParticipantEntity> participants, required this.bracketFormat, required this.dojangSeparation, required this.includeThirdPlaceMatch}): _participants = participants;
  

 final  List<ParticipantEntity> _participants;
 List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The elimination format to generate.
 final  BracketFormat bracketFormat;
/// Whether to apply dojang (gym) separation seeding.
 final  bool dojangSeparation;
 final  bool includeThirdPlaceMatch;

/// Create a copy of BracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketGenerateRequestedCopyWith<BracketGenerateRequested> get copyWith => _$BracketGenerateRequestedCopyWithImpl<BracketGenerateRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketGenerateRequested&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.bracketFormat, bracketFormat) || other.bracketFormat == bracketFormat)&&(identical(other.dojangSeparation, dojangSeparation) || other.dojangSeparation == dojangSeparation)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_participants),bracketFormat,dojangSeparation,includeThirdPlaceMatch);

@override
String toString() {
  return 'BracketEvent.generateRequested(participants: $participants, bracketFormat: $bracketFormat, dojangSeparation: $dojangSeparation, includeThirdPlaceMatch: $includeThirdPlaceMatch)';
}


}

/// @nodoc
abstract mixin class $BracketGenerateRequestedCopyWith<$Res> implements $BracketEventCopyWith<$Res> {
  factory $BracketGenerateRequestedCopyWith(BracketGenerateRequested value, $Res Function(BracketGenerateRequested) _then) = _$BracketGenerateRequestedCopyWithImpl;
@useResult
$Res call({
 List<ParticipantEntity> participants, BracketFormat bracketFormat, bool dojangSeparation, bool includeThirdPlaceMatch
});




}
/// @nodoc
class _$BracketGenerateRequestedCopyWithImpl<$Res>
    implements $BracketGenerateRequestedCopyWith<$Res> {
  _$BracketGenerateRequestedCopyWithImpl(this._self, this._then);

  final BracketGenerateRequested _self;
  final $Res Function(BracketGenerateRequested) _then;

/// Create a copy of BracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participants = null,Object? bracketFormat = null,Object? dojangSeparation = null,Object? includeThirdPlaceMatch = null,}) {
  return _then(BracketGenerateRequested(
participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,bracketFormat: null == bracketFormat ? _self.bracketFormat : bracketFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,dojangSeparation: null == dojangSeparation ? _self.dojangSeparation : dojangSeparation // ignore: cast_nullable_to_non_nullable
as bool,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class BracketRegenerateRequested implements BracketEvent {
  const BracketRegenerateRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketRegenerateRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketEvent.regenerateRequested()';
}


}




/// @nodoc


class BracketMatchResultRecorded implements BracketEvent {
  const BracketMatchResultRecorded({required this.matchId, required this.winnerId, required this.resultType, this.blueScore, this.redScore});
  

 final  String matchId;
 final  String winnerId;
 final  MatchResultType resultType;
 final  int? blueScore;
 final  int? redScore;

/// Create a copy of BracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketMatchResultRecordedCopyWith<BracketMatchResultRecorded> get copyWith => _$BracketMatchResultRecordedCopyWithImpl<BracketMatchResultRecorded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketMatchResultRecorded&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.resultType, resultType) || other.resultType == resultType)&&(identical(other.blueScore, blueScore) || other.blueScore == blueScore)&&(identical(other.redScore, redScore) || other.redScore == redScore));
}


@override
int get hashCode => Object.hash(runtimeType,matchId,winnerId,resultType,blueScore,redScore);

@override
String toString() {
  return 'BracketEvent.matchResultRecorded(matchId: $matchId, winnerId: $winnerId, resultType: $resultType, blueScore: $blueScore, redScore: $redScore)';
}


}

/// @nodoc
abstract mixin class $BracketMatchResultRecordedCopyWith<$Res> implements $BracketEventCopyWith<$Res> {
  factory $BracketMatchResultRecordedCopyWith(BracketMatchResultRecorded value, $Res Function(BracketMatchResultRecorded) _then) = _$BracketMatchResultRecordedCopyWithImpl;
@useResult
$Res call({
 String matchId, String winnerId, MatchResultType resultType, int? blueScore, int? redScore
});




}
/// @nodoc
class _$BracketMatchResultRecordedCopyWithImpl<$Res>
    implements $BracketMatchResultRecordedCopyWith<$Res> {
  _$BracketMatchResultRecordedCopyWithImpl(this._self, this._then);

  final BracketMatchResultRecorded _self;
  final $Res Function(BracketMatchResultRecorded) _then;

/// Create a copy of BracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? winnerId = null,Object? resultType = null,Object? blueScore = freezed,Object? redScore = freezed,}) {
  return _then(BracketMatchResultRecorded(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,resultType: null == resultType ? _self.resultType : resultType // ignore: cast_nullable_to_non_nullable
as MatchResultType,blueScore: freezed == blueScore ? _self.blueScore : blueScore // ignore: cast_nullable_to_non_nullable
as int?,redScore: freezed == redScore ? _self.redScore : redScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class BracketErrorDismissed implements BracketEvent {
  const BracketErrorDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketErrorDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketEvent.errorDismissed()';
}


}




// dart format on
