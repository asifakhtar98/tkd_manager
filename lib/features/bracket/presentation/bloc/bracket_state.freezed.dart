// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketState()';
}


}

/// @nodoc
class $BracketStateCopyWith<$Res>  {
$BracketStateCopyWith(BracketState _, $Res Function(BracketState) __);
}


/// Adds pattern-matching-related methods to [BracketState].
extension BracketStatePatterns on BracketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketInitial value)?  initial,TResult Function( BracketGenerating value)?  generating,TResult Function( BracketLoadSuccess value)?  loadSuccess,TResult Function( BracketFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial(_that);case BracketGenerating() when generating != null:
return generating(_that);case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case BracketFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketInitial value)  initial,required TResult Function( BracketGenerating value)  generating,required TResult Function( BracketLoadSuccess value)  loadSuccess,required TResult Function( BracketFailure value)  failure,}){
final _that = this;
switch (_that) {
case BracketInitial():
return initial(_that);case BracketGenerating():
return generating(_that);case BracketLoadSuccess():
return loadSuccess(_that);case BracketFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketInitial value)?  initial,TResult? Function( BracketGenerating value)?  generating,TResult? Function( BracketLoadSuccess value)?  loadSuccess,TResult? Function( BracketFailure value)?  failure,}){
final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial(_that);case BracketGenerating() when generating != null:
return generating(_that);case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case BracketFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  generating,TResult Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants,  bool isSaving,  bool hasUnsavedChanges,  DateTime? lastSaveTimestamp,  String? saveError)?  loadSuccess,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.initialResult,_that.initialParticipants,_that.isSaving,_that.hasUnsavedChanges,_that.lastSaveTimestamp,_that.saveError);case BracketFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  generating,required TResult Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants,  bool isSaving,  bool hasUnsavedChanges,  DateTime? lastSaveTimestamp,  String? saveError)  loadSuccess,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case BracketInitial():
return initial();case BracketGenerating():
return generating();case BracketLoadSuccess():
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.initialResult,_that.initialParticipants,_that.isSaving,_that.hasUnsavedChanges,_that.lastSaveTimestamp,_that.saveError);case BracketFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  generating,TResult? Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants,  bool isSaving,  bool hasUnsavedChanges,  DateTime? lastSaveTimestamp,  String? saveError)?  loadSuccess,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.initialResult,_that.initialParticipants,_that.isSaving,_that.hasUnsavedChanges,_that.lastSaveTimestamp,_that.saveError);case BracketFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BracketInitial implements BracketState {
  const BracketInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketState.initial()';
}


}




/// @nodoc


class BracketGenerating implements BracketState {
  const BracketGenerating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketGenerating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketState.generating()';
}


}




/// @nodoc


class BracketLoadSuccess implements BracketState {
  const BracketLoadSuccess({required this.result, required final  List<ParticipantEntity> participants, required this.format, required this.includeThirdPlaceMatch, this.errorMessage, final  List<BracketHistoryEntry> actionHistory = const [], this.historyPointer = -1, this.isReplayInProgress = false, this.initialResult, final  List<ParticipantEntity>? initialParticipants, this.isSaving = false, this.hasUnsavedChanges = false, this.lastSaveTimestamp, this.saveError}): _participants = participants,_actionHistory = actionHistory,_initialParticipants = initialParticipants;
  

 final  BracketResult result;
 final  List<ParticipantEntity> _participants;
 List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  BracketFormat format;
 final  bool includeThirdPlaceMatch;
 final  String? errorMessage;
 final  List<BracketHistoryEntry> _actionHistory;
@JsonKey() List<BracketHistoryEntry> get actionHistory {
  if (_actionHistory is EqualUnmodifiableListView) return _actionHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionHistory);
}

@JsonKey() final  int historyPointer;
@JsonKey() final  bool isReplayInProgress;
 final  BracketResult? initialResult;
 final  List<ParticipantEntity>? _initialParticipants;
 List<ParticipantEntity>? get initialParticipants {
  final value = _initialParticipants;
  if (value == null) return null;
  if (_initialParticipants is EqualUnmodifiableListView) return _initialParticipants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@JsonKey() final  bool isSaving;
@JsonKey() final  bool hasUnsavedChanges;
 final  DateTime? lastSaveTimestamp;
 final  String? saveError;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketLoadSuccessCopyWith<BracketLoadSuccess> get copyWith => _$BracketLoadSuccessCopyWithImpl<BracketLoadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketLoadSuccess&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.format, format) || other.format == format)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._actionHistory, _actionHistory)&&(identical(other.historyPointer, historyPointer) || other.historyPointer == historyPointer)&&(identical(other.isReplayInProgress, isReplayInProgress) || other.isReplayInProgress == isReplayInProgress)&&(identical(other.initialResult, initialResult) || other.initialResult == initialResult)&&const DeepCollectionEquality().equals(other._initialParticipants, _initialParticipants)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.hasUnsavedChanges, hasUnsavedChanges) || other.hasUnsavedChanges == hasUnsavedChanges)&&(identical(other.lastSaveTimestamp, lastSaveTimestamp) || other.lastSaveTimestamp == lastSaveTimestamp)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,result,const DeepCollectionEquality().hash(_participants),format,includeThirdPlaceMatch,errorMessage,const DeepCollectionEquality().hash(_actionHistory),historyPointer,isReplayInProgress,initialResult,const DeepCollectionEquality().hash(_initialParticipants),isSaving,hasUnsavedChanges,lastSaveTimestamp,saveError);

@override
String toString() {
  return 'BracketState.loadSuccess(result: $result, participants: $participants, format: $format, includeThirdPlaceMatch: $includeThirdPlaceMatch, errorMessage: $errorMessage, actionHistory: $actionHistory, historyPointer: $historyPointer, isReplayInProgress: $isReplayInProgress, initialResult: $initialResult, initialParticipants: $initialParticipants, isSaving: $isSaving, hasUnsavedChanges: $hasUnsavedChanges, lastSaveTimestamp: $lastSaveTimestamp, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class $BracketLoadSuccessCopyWith<$Res> implements $BracketStateCopyWith<$Res> {
  factory $BracketLoadSuccessCopyWith(BracketLoadSuccess value, $Res Function(BracketLoadSuccess) _then) = _$BracketLoadSuccessCopyWithImpl;
@useResult
$Res call({
 BracketResult result, List<ParticipantEntity> participants, BracketFormat format, bool includeThirdPlaceMatch, String? errorMessage, List<BracketHistoryEntry> actionHistory, int historyPointer, bool isReplayInProgress, BracketResult? initialResult, List<ParticipantEntity>? initialParticipants, bool isSaving, bool hasUnsavedChanges, DateTime? lastSaveTimestamp, String? saveError
});


$BracketResultCopyWith<$Res> get result;$BracketResultCopyWith<$Res>? get initialResult;

}
/// @nodoc
class _$BracketLoadSuccessCopyWithImpl<$Res>
    implements $BracketLoadSuccessCopyWith<$Res> {
  _$BracketLoadSuccessCopyWithImpl(this._self, this._then);

  final BracketLoadSuccess _self;
  final $Res Function(BracketLoadSuccess) _then;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? participants = null,Object? format = null,Object? includeThirdPlaceMatch = null,Object? errorMessage = freezed,Object? actionHistory = null,Object? historyPointer = null,Object? isReplayInProgress = null,Object? initialResult = freezed,Object? initialParticipants = freezed,Object? isSaving = null,Object? hasUnsavedChanges = null,Object? lastSaveTimestamp = freezed,Object? saveError = freezed,}) {
  return _then(BracketLoadSuccess(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,actionHistory: null == actionHistory ? _self._actionHistory : actionHistory // ignore: cast_nullable_to_non_nullable
as List<BracketHistoryEntry>,historyPointer: null == historyPointer ? _self.historyPointer : historyPointer // ignore: cast_nullable_to_non_nullable
as int,isReplayInProgress: null == isReplayInProgress ? _self.isReplayInProgress : isReplayInProgress // ignore: cast_nullable_to_non_nullable
as bool,initialResult: freezed == initialResult ? _self.initialResult : initialResult // ignore: cast_nullable_to_non_nullable
as BracketResult?,initialParticipants: freezed == initialParticipants ? _self._initialParticipants : initialParticipants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,hasUnsavedChanges: null == hasUnsavedChanges ? _self.hasUnsavedChanges : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
as bool,lastSaveTimestamp: freezed == lastSaveTimestamp ? _self.lastSaveTimestamp : lastSaveTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get result {
  
  return $BracketResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res>? get initialResult {
    if (_self.initialResult == null) {
    return null;
  }

  return $BracketResultCopyWith<$Res>(_self.initialResult!, (value) {
    return _then(_self.copyWith(initialResult: value));
  });
}
}

/// @nodoc


class BracketFailure implements BracketState {
  const BracketFailure(this.message);
  

 final  String message;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketFailureCopyWith<BracketFailure> get copyWith => _$BracketFailureCopyWithImpl<BracketFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BracketState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $BracketFailureCopyWith<$Res> implements $BracketStateCopyWith<$Res> {
  factory $BracketFailureCopyWith(BracketFailure value, $Res Function(BracketFailure) _then) = _$BracketFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BracketFailureCopyWithImpl<$Res>
    implements $BracketFailureCopyWith<$Res> {
  _$BracketFailureCopyWithImpl(this._self, this._then);

  final BracketFailure _self;
  final $Res Function(BracketFailure) _then;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BracketFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
