// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
BracketResult _$BracketResultFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'singleElimination':
          return SingleEliminationResult.fromJson(
            json
          );
                case 'doubleElimination':
          return DoubleEliminationResult.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'BracketResult',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$BracketResult {

 Object get data;

  /// Serializes this BracketResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketResult&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class SingleEliminationResult extends BracketResult {
  const SingleEliminationResult(this.data, {final  String? $type}): $type = $type ?? 'singleElimination',super._();
  factory SingleEliminationResult.fromJson(Map<String, dynamic> json) => _$SingleEliminationResultFromJson(json);

@override final  BracketGenerationResult data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SingleEliminationResultCopyWith<SingleEliminationResult> get copyWith => _$SingleEliminationResultCopyWithImpl<SingleEliminationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SingleEliminationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SingleEliminationResult&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class DoubleEliminationResult extends BracketResult {
  const DoubleEliminationResult(this.data, {final  String? $type}): $type = $type ?? 'doubleElimination',super._();
  factory DoubleEliminationResult.fromJson(Map<String, dynamic> json) => _$DoubleEliminationResultFromJson(json);

@override final  DoubleEliminationBracketGenerationResult data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BracketResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoubleEliminationResultCopyWith<DoubleEliminationResult> get copyWith => _$DoubleEliminationResultCopyWithImpl<DoubleEliminationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoubleEliminationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoubleEliminationResult&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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

BracketAction _$BracketActionFromJson(
  Map<String, dynamic> json
) {
    return BracketActionMatchResult.fromJson(
      json
    );
}

/// @nodoc
mixin _$BracketAction {

 BracketMatchAction get data;
/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketActionCopyWith<BracketAction> get copyWith => _$BracketActionCopyWithImpl<BracketAction>(this as BracketAction, _$identity);

  /// Serializes this BracketAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketAction&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BracketAction(data: $data)';
}


}

/// @nodoc
abstract mixin class $BracketActionCopyWith<$Res>  {
  factory $BracketActionCopyWith(BracketAction value, $Res Function(BracketAction) _then) = _$BracketActionCopyWithImpl;
@useResult
$Res call({
 BracketMatchAction data
});


$BracketMatchActionCopyWith<$Res> get data;

}
/// @nodoc
class _$BracketActionCopyWithImpl<$Res>
    implements $BracketActionCopyWith<$Res> {
  _$BracketActionCopyWithImpl(this._self, this._then);

  final BracketAction _self;
  final $Res Function(BracketAction) _then;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketActionMatchResult value)?  matchResult,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketActionMatchResult value)  matchResult,}){
final _that = this;
switch (_that) {
case BracketActionMatchResult():
return matchResult(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketActionMatchResult value)?  matchResult,}){
final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BracketMatchAction data)?  matchResult,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BracketMatchAction data)  matchResult,}) {final _that = this;
switch (_that) {
case BracketActionMatchResult():
return matchResult(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BracketMatchAction data)?  matchResult,}) {final _that = this;
switch (_that) {
case BracketActionMatchResult() when matchResult != null:
return matchResult(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BracketActionMatchResult implements BracketAction {
  const BracketActionMatchResult(this.data);
  factory BracketActionMatchResult.fromJson(Map<String, dynamic> json) => _$BracketActionMatchResultFromJson(json);

@override final  BracketMatchAction data;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketActionMatchResultCopyWith<BracketActionMatchResult> get copyWith => _$BracketActionMatchResultCopyWithImpl<BracketActionMatchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketActionMatchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketActionMatchResult&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
$Res call({
 BracketMatchAction data
});


@override $BracketMatchActionCopyWith<$Res> get data;

}
/// @nodoc
class _$BracketActionMatchResultCopyWithImpl<$Res>
    implements $BracketActionMatchResultCopyWith<$Res> {
  _$BracketActionMatchResultCopyWithImpl(this._self, this._then);

  final BracketActionMatchResult _self;
  final $Res Function(BracketActionMatchResult) _then;

/// Create a copy of BracketAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
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
mixin _$BracketHistoryEntry {

 BracketAction get action; BracketResult get resultSnapshot; List<ParticipantEntity> get participantsSnapshot;
/// Create a copy of BracketHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketHistoryEntryCopyWith<BracketHistoryEntry> get copyWith => _$BracketHistoryEntryCopyWithImpl<BracketHistoryEntry>(this as BracketHistoryEntry, _$identity);

  /// Serializes this BracketHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketHistoryEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.resultSnapshot, resultSnapshot) || other.resultSnapshot == resultSnapshot)&&const DeepCollectionEquality().equals(other.participantsSnapshot, participantsSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()

class _BracketHistoryEntry implements BracketHistoryEntry {
  const _BracketHistoryEntry({required this.action, required this.resultSnapshot, required final  List<ParticipantEntity> participantsSnapshot}): _participantsSnapshot = participantsSnapshot;
  factory _BracketHistoryEntry.fromJson(Map<String, dynamic> json) => _$BracketHistoryEntryFromJson(json);

@override final  BracketAction action;
@override final  BracketResult resultSnapshot;
 final  List<ParticipantEntity> _participantsSnapshot;
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
Map<String, dynamic> toJson() {
  return _$BracketHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketHistoryEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.resultSnapshot, resultSnapshot) || other.resultSnapshot == resultSnapshot)&&const DeepCollectionEquality().equals(other._participantsSnapshot, _participantsSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
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

// dart format on
