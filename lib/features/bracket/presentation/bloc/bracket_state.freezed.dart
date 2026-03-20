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
mixin _$BracketAction {

 Object get data;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketAction&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'BracketAction(data: $data)';
}


}

/// @nodoc
class $BracketActionCopyWith<$Res>  {
$BracketActionCopyWith(BracketAction _, $Res Function(BracketAction) __);
}


/// Adds pattern-matching-related methods to [BracketAction].
extension BracketActionPatterns on BracketAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketActionMatchResult value)?  matchResult,TResult Function( BracketActionEditAction value)?  editAction,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that);case BracketActionEditAction() when editAction != null:
return editAction(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketActionMatchResult value)  matchResult,required TResult Function( BracketActionEditAction value)  editAction,}){
final _that = this;
switch (_that) {
case BracketActionMatchResult():
return matchResult(_that);case BracketActionEditAction():
return editAction(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketActionMatchResult value)?  matchResult,TResult? Function( BracketActionEditAction value)?  editAction,}){
final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that);case BracketActionEditAction() when editAction != null:
return editAction(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BracketMatchAction data)?  matchResult,TResult Function( BracketEditAction data)?  editAction,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that.data);case BracketActionEditAction() when editAction != null:
return editAction(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BracketMatchAction data)  matchResult,required TResult Function( BracketEditAction data)  editAction,}) {final _that = this;
switch (_that) {
case BracketActionMatchResult():
return matchResult(_that.data);case BracketActionEditAction():
return editAction(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BracketMatchAction data)?  matchResult,TResult? Function( BracketEditAction data)?  editAction,}) {final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that.data);case BracketActionEditAction() when editAction != null:
return editAction(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class BracketActionMatchResult implements BracketAction {
  const BracketActionMatchResult(this.data);
  

@override final  BracketMatchAction data;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketActionMatchResultCopyWith<BracketActionMatchResult> get copyWith => _$BracketActionMatchResultCopyWithImpl<BracketActionMatchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketActionMatchResult&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BracketAction.matchResult(data: $data)';
}


}

/// @nodoc
abstract mixin class $BracketActionMatchResultCopyWith<$Res> implements $BracketActionCopyWith<$Res> {
  factory $BracketActionMatchResultCopyWith(BracketActionMatchResult value, $Res Function(BracketActionMatchResult) _then) = _$BracketActionMatchResultCopyWithImpl;
@useResult
$Res call({
 BracketMatchAction data
});


$BracketMatchActionCopyWith<$Res> get data;

}
/// @nodoc
class _$BracketActionMatchResultCopyWithImpl<$Res>
    implements $BracketActionMatchResultCopyWith<$Res> {
  _$BracketActionMatchResultCopyWithImpl(this._self, this._then);

  final BracketActionMatchResult _self;
  final $Res Function(BracketActionMatchResult) _then;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(BracketActionMatchResult(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BracketMatchAction,
  ));
}

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketMatchActionCopyWith<$Res> get data {
  
  return $BracketMatchActionCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class BracketActionEditAction implements BracketAction {
  const BracketActionEditAction(this.data);
  

@override final  BracketEditAction data;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketActionEditActionCopyWith<BracketActionEditAction> get copyWith => _$BracketActionEditActionCopyWithImpl<BracketActionEditAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketActionEditAction&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BracketAction.editAction(data: $data)';
}


}

/// @nodoc
abstract mixin class $BracketActionEditActionCopyWith<$Res> implements $BracketActionCopyWith<$Res> {
  factory $BracketActionEditActionCopyWith(BracketActionEditAction value, $Res Function(BracketActionEditAction) _then) = _$BracketActionEditActionCopyWithImpl;
@useResult
$Res call({
 BracketEditAction data
});


$BracketEditActionCopyWith<$Res> get data;

}
/// @nodoc
class _$BracketActionEditActionCopyWithImpl<$Res>
    implements $BracketActionEditActionCopyWith<$Res> {
  _$BracketActionEditActionCopyWithImpl(this._self, this._then);

  final BracketActionEditAction _self;
  final $Res Function(BracketActionEditAction) _then;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(BracketActionEditAction(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BracketEditAction,
  ));
}

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEditActionCopyWith<$Res> get data {
  
  return $BracketEditActionCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$BracketHistoryEntry {

/// Type-safe action metadata (match result or bracket edit).
 BracketAction get action;/// The full bracket result snapshot AFTER this action was applied.
 BracketResult get resultSnapshot;/// The full participants list snapshot AFTER this action was applied.
/// Needed because name/ID edits mutate participants, not matches.
 List<ParticipantEntity> get participantsSnapshot;
/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketHistoryEntryCopyWith<BracketHistoryEntry> get copyWith => _$BracketHistoryEntryCopyWithImpl<BracketHistoryEntry>(this as BracketHistoryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketHistoryEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.resultSnapshot, resultSnapshot) || other.resultSnapshot == resultSnapshot)&&const DeepCollectionEquality().equals(other.participantsSnapshot, participantsSnapshot));
}


@override
int get hashCode => Object.hash(runtimeType,action,resultSnapshot,const DeepCollectionEquality().hash(participantsSnapshot));

@override
String toString() {
  return 'BracketHistoryEntry(action: $action, resultSnapshot: $resultSnapshot, participantsSnapshot: $participantsSnapshot)';
}


}

/// @nodoc
abstract mixin class $BracketHistoryEntryCopyWith<$Res>  {
  factory $BracketHistoryEntryCopyWith(BracketHistoryEntry value, $Res Function(BracketHistoryEntry) _then) = _$BracketHistoryEntryCopyWithImpl;
@useResult
$Res call({
 BracketAction action, BracketResult resultSnapshot, List<ParticipantEntity> participantsSnapshot
});


$BracketActionCopyWith<$Res> get action;$BracketResultCopyWith<$Res> get resultSnapshot;

}
/// @nodoc
class _$BracketHistoryEntryCopyWithImpl<$Res>
    implements $BracketHistoryEntryCopyWith<$Res> {
  _$BracketHistoryEntryCopyWithImpl(this._self, this._then);

  final BracketHistoryEntry _self;
  final $Res Function(BracketHistoryEntry) _then;

/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? resultSnapshot = null,Object? participantsSnapshot = null,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BracketAction,resultSnapshot: null == resultSnapshot ? _self.resultSnapshot : resultSnapshot // ignore: cast_nullable_to_non_nullable
as BracketResult,participantsSnapshot: null == participantsSnapshot ? _self.participantsSnapshot : participantsSnapshot // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,
  ));
}
/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketActionCopyWith<$Res> get action {
  
  return $BracketActionCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get resultSnapshot {
  
  return $BracketResultCopyWith<$Res>(_self.resultSnapshot, (value) {
    return _then(_self.copyWith(resultSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketHistoryEntry].
extension BracketHistoryEntryPatterns on BracketHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _BracketHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BracketHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BracketAction action,  BracketResult resultSnapshot,  List<ParticipantEntity> participantsSnapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketHistoryEntry() when $default != null:
return $default(_that.action,_that.resultSnapshot,_that.participantsSnapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BracketAction action,  BracketResult resultSnapshot,  List<ParticipantEntity> participantsSnapshot)  $default,) {final _that = this;
switch (_that) {
case _BracketHistoryEntry():
return $default(_that.action,_that.resultSnapshot,_that.participantsSnapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BracketAction action,  BracketResult resultSnapshot,  List<ParticipantEntity> participantsSnapshot)?  $default,) {final _that = this;
switch (_that) {
case _BracketHistoryEntry() when $default != null:
return $default(_that.action,_that.resultSnapshot,_that.participantsSnapshot);case _:
  return null;

}
}

}

/// @nodoc


class _BracketHistoryEntry implements BracketHistoryEntry {
  const _BracketHistoryEntry({required this.action, required this.resultSnapshot, required final  List<ParticipantEntity> participantsSnapshot}): _participantsSnapshot = participantsSnapshot;
  

/// Type-safe action metadata (match result or bracket edit).
@override final  BracketAction action;
/// The full bracket result snapshot AFTER this action was applied.
@override final  BracketResult resultSnapshot;
/// The full participants list snapshot AFTER this action was applied.
/// Needed because name/ID edits mutate participants, not matches.
 final  List<ParticipantEntity> _participantsSnapshot;
/// The full participants list snapshot AFTER this action was applied.
/// Needed because name/ID edits mutate participants, not matches.
@override List<ParticipantEntity> get participantsSnapshot {
  if (_participantsSnapshot is EqualUnmodifiableListView) return _participantsSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantsSnapshot);
}


/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketHistoryEntryCopyWith<_BracketHistoryEntry> get copyWith => __$BracketHistoryEntryCopyWithImpl<_BracketHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketHistoryEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.resultSnapshot, resultSnapshot) || other.resultSnapshot == resultSnapshot)&&const DeepCollectionEquality().equals(other._participantsSnapshot, _participantsSnapshot));
}


@override
int get hashCode => Object.hash(runtimeType,action,resultSnapshot,const DeepCollectionEquality().hash(_participantsSnapshot));

@override
String toString() {
  return 'BracketHistoryEntry(action: $action, resultSnapshot: $resultSnapshot, participantsSnapshot: $participantsSnapshot)';
}


}

/// @nodoc
abstract mixin class _$BracketHistoryEntryCopyWith<$Res> implements $BracketHistoryEntryCopyWith<$Res> {
  factory _$BracketHistoryEntryCopyWith(_BracketHistoryEntry value, $Res Function(_BracketHistoryEntry) _then) = __$BracketHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 BracketAction action, BracketResult resultSnapshot, List<ParticipantEntity> participantsSnapshot
});


@override $BracketActionCopyWith<$Res> get action;@override $BracketResultCopyWith<$Res> get resultSnapshot;

}
/// @nodoc
class __$BracketHistoryEntryCopyWithImpl<$Res>
    implements _$BracketHistoryEntryCopyWith<$Res> {
  __$BracketHistoryEntryCopyWithImpl(this._self, this._then);

  final _BracketHistoryEntry _self;
  final $Res Function(_BracketHistoryEntry) _then;

/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? resultSnapshot = null,Object? participantsSnapshot = null,}) {
  return _then(_BracketHistoryEntry(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BracketAction,resultSnapshot: null == resultSnapshot ? _self.resultSnapshot : resultSnapshot // ignore: cast_nullable_to_non_nullable
as BracketResult,participantsSnapshot: null == participantsSnapshot ? _self._participantsSnapshot : participantsSnapshot // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,
  ));
}

/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketActionCopyWith<$Res> get action {
  
  return $BracketActionCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get resultSnapshot {
  
  return $BracketResultCopyWith<$Res>(_self.resultSnapshot, (value) {
    return _then(_self.copyWith(resultSnapshot: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  generating,TResult Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  bool isEditModeEnabled,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants)?  loadSuccess,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.isEditModeEnabled,_that.initialResult,_that.initialParticipants);case BracketFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  generating,required TResult Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  bool isEditModeEnabled,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants)  loadSuccess,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case BracketInitial():
return initial();case BracketGenerating():
return generating();case BracketLoadSuccess():
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.isEditModeEnabled,_that.initialResult,_that.initialParticipants);case BracketFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  generating,TResult? Function( BracketResult result,  List<ParticipantEntity> participants,  BracketFormat format,  bool includeThirdPlaceMatch,  String? errorMessage,  List<BracketHistoryEntry> actionHistory,  int historyPointer,  bool isReplayInProgress,  bool isEditModeEnabled,  BracketResult? initialResult,  List<ParticipantEntity>? initialParticipants)?  loadSuccess,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case BracketInitial() when initial != null:
return initial();case BracketGenerating() when generating != null:
return generating();case BracketLoadSuccess() when loadSuccess != null:
return loadSuccess(_that.result,_that.participants,_that.format,_that.includeThirdPlaceMatch,_that.errorMessage,_that.actionHistory,_that.historyPointer,_that.isReplayInProgress,_that.isEditModeEnabled,_that.initialResult,_that.initialParticipants);case BracketFailure() when failure != null:
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
  const BracketLoadSuccess({required this.result, required final  List<ParticipantEntity> participants, required this.format, required this.includeThirdPlaceMatch, this.errorMessage, final  List<BracketHistoryEntry> actionHistory = const [], this.historyPointer = -1, this.isReplayInProgress = false, this.isEditModeEnabled = false, this.initialResult, final  List<ParticipantEntity>? initialParticipants}): _participants = participants,_actionHistory = actionHistory,_initialParticipants = initialParticipants;
  

 final  BracketResult result;
 final  List<ParticipantEntity> _participants;
 List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The elimination format that was used to generate this bracket.
 final  BracketFormat format;
 final  bool includeThirdPlaceMatch;
 final  String? errorMessage;
/// Chronological list of all actions taken since generation.
/// The initial (generation) state is NOT in this list — it is stored as
/// [initialResult] / [initialParticipants] below.
 final  List<BracketHistoryEntry> _actionHistory;
/// Chronological list of all actions taken since generation.
/// The initial (generation) state is NOT in this list — it is stored as
/// [initialResult] / [initialParticipants] below.
@JsonKey() List<BracketHistoryEntry> get actionHistory {
  if (_actionHistory is EqualUnmodifiableListView) return _actionHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionHistory);
}

/// Pointer into [actionHistory]. -1 means we are at the initial
/// (pre-any-action) state. 0 means after the first action, etc.
@JsonKey() final  int historyPointer;
/// True when an animated replay is in progress.
@JsonKey() final  bool isReplayInProgress;
/// True when bracket edit mode (drag-swap / tap-edit) is active.
@JsonKey() final  bool isEditModeEnabled;
/// The bracket result immediately after generation, before any
/// actions were applied. Used as the baseline for undo and replay.
 final  BracketResult? initialResult;
/// The participants list immediately after generation, before any
/// name/ID edits were applied. Used as the baseline for undo.
 final  List<ParticipantEntity>? _initialParticipants;
/// The participants list immediately after generation, before any
/// name/ID edits were applied. Used as the baseline for undo.
 List<ParticipantEntity>? get initialParticipants {
  final value = _initialParticipants;
  if (value == null) return null;
  if (_initialParticipants is EqualUnmodifiableListView) return _initialParticipants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BracketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketLoadSuccessCopyWith<BracketLoadSuccess> get copyWith => _$BracketLoadSuccessCopyWithImpl<BracketLoadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketLoadSuccess&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.format, format) || other.format == format)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._actionHistory, _actionHistory)&&(identical(other.historyPointer, historyPointer) || other.historyPointer == historyPointer)&&(identical(other.isReplayInProgress, isReplayInProgress) || other.isReplayInProgress == isReplayInProgress)&&(identical(other.isEditModeEnabled, isEditModeEnabled) || other.isEditModeEnabled == isEditModeEnabled)&&(identical(other.initialResult, initialResult) || other.initialResult == initialResult)&&const DeepCollectionEquality().equals(other._initialParticipants, _initialParticipants));
}


@override
int get hashCode => Object.hash(runtimeType,result,const DeepCollectionEquality().hash(_participants),format,includeThirdPlaceMatch,errorMessage,const DeepCollectionEquality().hash(_actionHistory),historyPointer,isReplayInProgress,isEditModeEnabled,initialResult,const DeepCollectionEquality().hash(_initialParticipants));

@override
String toString() {
  return 'BracketState.loadSuccess(result: $result, participants: $participants, format: $format, includeThirdPlaceMatch: $includeThirdPlaceMatch, errorMessage: $errorMessage, actionHistory: $actionHistory, historyPointer: $historyPointer, isReplayInProgress: $isReplayInProgress, isEditModeEnabled: $isEditModeEnabled, initialResult: $initialResult, initialParticipants: $initialParticipants)';
}


}

/// @nodoc
abstract mixin class $BracketLoadSuccessCopyWith<$Res> implements $BracketStateCopyWith<$Res> {
  factory $BracketLoadSuccessCopyWith(BracketLoadSuccess value, $Res Function(BracketLoadSuccess) _then) = _$BracketLoadSuccessCopyWithImpl;
@useResult
$Res call({
 BracketResult result, List<ParticipantEntity> participants, BracketFormat format, bool includeThirdPlaceMatch, String? errorMessage, List<BracketHistoryEntry> actionHistory, int historyPointer, bool isReplayInProgress, bool isEditModeEnabled, BracketResult? initialResult, List<ParticipantEntity>? initialParticipants
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
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? participants = null,Object? format = null,Object? includeThirdPlaceMatch = null,Object? errorMessage = freezed,Object? actionHistory = null,Object? historyPointer = null,Object? isReplayInProgress = null,Object? isEditModeEnabled = null,Object? initialResult = freezed,Object? initialParticipants = freezed,}) {
  return _then(BracketLoadSuccess(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,actionHistory: null == actionHistory ? _self._actionHistory : actionHistory // ignore: cast_nullable_to_non_nullable
as List<BracketHistoryEntry>,historyPointer: null == historyPointer ? _self.historyPointer : historyPointer // ignore: cast_nullable_to_non_nullable
as int,isReplayInProgress: null == isReplayInProgress ? _self.isReplayInProgress : isReplayInProgress // ignore: cast_nullable_to_non_nullable
as bool,isEditModeEnabled: null == isEditModeEnabled ? _self.isEditModeEnabled : isEditModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,initialResult: freezed == initialResult ? _self.initialResult : initialResult // ignore: cast_nullable_to_non_nullable
as BracketResult?,initialParticipants: freezed == initialParticipants ? _self._initialParticipants : initialParticipants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>?,
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
