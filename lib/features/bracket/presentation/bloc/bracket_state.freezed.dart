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
mixin _$BracketResult {

 Object get data;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketResult&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'BracketResult(data: $data)';
}


}

/// @nodoc
class $BracketResultCopyWith<$Res>  {
$BracketResultCopyWith(BracketResult _, $Res Function(BracketResult) __);
}


/// Adds pattern-matching-related methods to [BracketResult].
extension BracketResultPatterns on BracketResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SingleEliminationResult value)?  singleElimination,TResult Function( DoubleEliminationResult value)?  doubleElimination,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SingleEliminationResult() when singleElimination != null:
return singleElimination(_that);case DoubleEliminationResult() when doubleElimination != null:
return doubleElimination(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SingleEliminationResult value)  singleElimination,required TResult Function( DoubleEliminationResult value)  doubleElimination,}){
final _that = this;
switch (_that) {
case SingleEliminationResult():
return singleElimination(_that);case DoubleEliminationResult():
return doubleElimination(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SingleEliminationResult value)?  singleElimination,TResult? Function( DoubleEliminationResult value)?  doubleElimination,}){
final _that = this;
switch (_that) {
case SingleEliminationResult() when singleElimination != null:
return singleElimination(_that);case DoubleEliminationResult() when doubleElimination != null:
return doubleElimination(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BracketGenerationResult data)?  singleElimination,TResult Function( DoubleEliminationBracketGenerationResult data)?  doubleElimination,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SingleEliminationResult() when singleElimination != null:
return singleElimination(_that.data);case DoubleEliminationResult() when doubleElimination != null:
return doubleElimination(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BracketGenerationResult data)  singleElimination,required TResult Function( DoubleEliminationBracketGenerationResult data)  doubleElimination,}) {final _that = this;
switch (_that) {
case SingleEliminationResult():
return singleElimination(_that.data);case DoubleEliminationResult():
return doubleElimination(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BracketGenerationResult data)?  singleElimination,TResult? Function( DoubleEliminationBracketGenerationResult data)?  doubleElimination,}) {final _that = this;
switch (_that) {
case SingleEliminationResult() when singleElimination != null:
return singleElimination(_that.data);case DoubleEliminationResult() when doubleElimination != null:
return doubleElimination(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class SingleEliminationResult implements BracketResult {
  const SingleEliminationResult(this.data);
  

@override final  BracketGenerationResult data;

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SingleEliminationResultCopyWith<SingleEliminationResult> get copyWith => _$SingleEliminationResultCopyWithImpl<SingleEliminationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SingleEliminationResult&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BracketResult.singleElimination(data: $data)';
}


}

/// @nodoc
abstract mixin class $SingleEliminationResultCopyWith<$Res> implements $BracketResultCopyWith<$Res> {
  factory $SingleEliminationResultCopyWith(SingleEliminationResult value, $Res Function(SingleEliminationResult) _then) = _$SingleEliminationResultCopyWithImpl;
@useResult
$Res call({
 BracketGenerationResult data
});


$BracketGenerationResultCopyWith<$Res> get data;

}
/// @nodoc
class _$SingleEliminationResultCopyWithImpl<$Res>
    implements $SingleEliminationResultCopyWith<$Res> {
  _$SingleEliminationResultCopyWithImpl(this._self, this._then);

  final SingleEliminationResult _self;
  final $Res Function(SingleEliminationResult) _then;

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(SingleEliminationResult(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BracketGenerationResult,
  ));
}

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketGenerationResultCopyWith<$Res> get data {
  
  return $BracketGenerationResultCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class DoubleEliminationResult implements BracketResult {
  const DoubleEliminationResult(this.data);
  

@override final  DoubleEliminationBracketGenerationResult data;

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoubleEliminationResultCopyWith<DoubleEliminationResult> get copyWith => _$DoubleEliminationResultCopyWithImpl<DoubleEliminationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoubleEliminationResult&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BracketResult.doubleElimination(data: $data)';
}


}

/// @nodoc
abstract mixin class $DoubleEliminationResultCopyWith<$Res> implements $BracketResultCopyWith<$Res> {
  factory $DoubleEliminationResultCopyWith(DoubleEliminationResult value, $Res Function(DoubleEliminationResult) _then) = _$DoubleEliminationResultCopyWithImpl;
@useResult
$Res call({
 DoubleEliminationBracketGenerationResult data
});


$DoubleEliminationBracketGenerationResultCopyWith<$Res> get data;

}
/// @nodoc
class _$DoubleEliminationResultCopyWithImpl<$Res>
    implements $DoubleEliminationResultCopyWith<$Res> {
  _$DoubleEliminationResultCopyWithImpl(this._self, this._then);

  final DoubleEliminationResult _self;
  final $Res Function(DoubleEliminationResult) _then;

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(DoubleEliminationResult(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DoubleEliminationBracketGenerationResult,
  ));
}

/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoubleEliminationBracketGenerationResultCopyWith<$Res> get data {
  
  return $DoubleEliminationBracketGenerationResultCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  generating,TResult Function( BracketResult result,  List<ParticipantEntity> participants,  String format,  bool includeThirdPlaceMatch)?  loadSuccess,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch);case BracketFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  generating,required TResult Function( BracketResult result,  List<ParticipantEntity> participants,  String format,  bool includeThirdPlaceMatch)  loadSuccess,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case BracketInitial():
return initial();case BracketGenerating():
return generating();case BracketLoadSuccess():
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch);case BracketFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  generating,TResult? Function( BracketResult result,  List<ParticipantEntity> participants,  String format,  bool includeThirdPlaceMatch)?  loadSuccess,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch);case BracketFailure() when failure != null:
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
  const BracketLoadSuccess({required this.result, required final  List<ParticipantEntity> participants, required this.format, required this.includeThirdPlaceMatch}): _participants = participants;
  

 final  BracketResult result;
 final  List<ParticipantEntity> _participants;
 List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  String format;
 final  bool includeThirdPlaceMatch;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketLoadSuccessCopyWith<BracketLoadSuccess> get copyWith => _$BracketLoadSuccessCopyWithImpl<BracketLoadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketLoadSuccess&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.format, format) || other.format == format)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch));
}


@override
int get hashCode => Object.hash(runtimeType,result,const DeepCollectionEquality().hash(_participants),format,includeThirdPlaceMatch);

@override
String toString() {
  return 'BracketState.loadSuccess(result: $result, participants: $participants, format: $format, includeThirdPlaceMatch: $includeThirdPlaceMatch)';
}


}

/// @nodoc
abstract mixin class $BracketLoadSuccessCopyWith<$Res> implements $BracketStateCopyWith<$Res> {
  factory $BracketLoadSuccessCopyWith(BracketLoadSuccess value, $Res Function(BracketLoadSuccess) _then) = _$BracketLoadSuccessCopyWithImpl;
@useResult
$Res call({
 BracketResult result, List<ParticipantEntity> participants, String format, bool includeThirdPlaceMatch
});


$BracketResultCopyWith<$Res> get result;

}
/// @nodoc
class _$BracketLoadSuccessCopyWithImpl<$Res>
    implements $BracketLoadSuccessCopyWith<$Res> {
  _$BracketLoadSuccessCopyWithImpl(this._self, this._then);

  final BracketLoadSuccess _self;
  final $Res Function(BracketLoadSuccess) _then;

/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? participants = null,Object? format = null,Object? includeThirdPlaceMatch = null,}) {
  return _then(BracketLoadSuccess(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,
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
