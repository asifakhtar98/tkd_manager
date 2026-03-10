// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_generation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketGenerationResult {

 BracketEntity get bracket; List<MatchEntity> get matches;
/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketGenerationResultCopyWith<BracketGenerationResult> get copyWith => _$BracketGenerationResultCopyWithImpl<BracketGenerationResult>(this as BracketGenerationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketGenerationResult&&(identical(other.bracket, bracket) || other.bracket == bracket)&&const DeepCollectionEquality().equals(other.matches, matches));
}


@override
int get hashCode => Object.hash(runtimeType,bracket,const DeepCollectionEquality().hash(matches));

@override
String toString() {
  return 'BracketGenerationResult(bracket: $bracket, matches: $matches)';
}


}

/// @nodoc
abstract mixin class $BracketGenerationResultCopyWith<$Res>  {
  factory $BracketGenerationResultCopyWith(BracketGenerationResult value, $Res Function(BracketGenerationResult) _then) = _$BracketGenerationResultCopyWithImpl;
@useResult
$Res call({
 BracketEntity bracket, List<MatchEntity> matches
});


$BracketEntityCopyWith<$Res> get bracket;

}
/// @nodoc
class _$BracketGenerationResultCopyWithImpl<$Res>
    implements $BracketGenerationResultCopyWith<$Res> {
  _$BracketGenerationResultCopyWithImpl(this._self, this._then);

  final BracketGenerationResult _self;
  final $Res Function(BracketGenerationResult) _then;

/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bracket = null,Object? matches = null,}) {
  return _then(_self.copyWith(
bracket: null == bracket ? _self.bracket : bracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<MatchEntity>,
  ));
}
/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get bracket {
  
  return $BracketEntityCopyWith<$Res>(_self.bracket, (value) {
    return _then(_self.copyWith(bracket: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketGenerationResult].
extension BracketGenerationResultPatterns on BracketGenerationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketGenerationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketGenerationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketGenerationResult value)  $default,){
final _that = this;
switch (_that) {
case _BracketGenerationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketGenerationResult value)?  $default,){
final _that = this;
switch (_that) {
case _BracketGenerationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BracketEntity bracket,  List<MatchEntity> matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketGenerationResult() when $default != null:
return $default(_that.bracket,_that.matches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BracketEntity bracket,  List<MatchEntity> matches)  $default,) {final _that = this;
switch (_that) {
case _BracketGenerationResult():
return $default(_that.bracket,_that.matches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BracketEntity bracket,  List<MatchEntity> matches)?  $default,) {final _that = this;
switch (_that) {
case _BracketGenerationResult() when $default != null:
return $default(_that.bracket,_that.matches);case _:
  return null;

}
}

}

/// @nodoc


class _BracketGenerationResult implements BracketGenerationResult {
  const _BracketGenerationResult({required this.bracket, required final  List<MatchEntity> matches}): _matches = matches;
  

@override final  BracketEntity bracket;
 final  List<MatchEntity> _matches;
@override List<MatchEntity> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}


/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketGenerationResultCopyWith<_BracketGenerationResult> get copyWith => __$BracketGenerationResultCopyWithImpl<_BracketGenerationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketGenerationResult&&(identical(other.bracket, bracket) || other.bracket == bracket)&&const DeepCollectionEquality().equals(other._matches, _matches));
}


@override
int get hashCode => Object.hash(runtimeType,bracket,const DeepCollectionEquality().hash(_matches));

@override
String toString() {
  return 'BracketGenerationResult(bracket: $bracket, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$BracketGenerationResultCopyWith<$Res> implements $BracketGenerationResultCopyWith<$Res> {
  factory _$BracketGenerationResultCopyWith(_BracketGenerationResult value, $Res Function(_BracketGenerationResult) _then) = __$BracketGenerationResultCopyWithImpl;
@override @useResult
$Res call({
 BracketEntity bracket, List<MatchEntity> matches
});


@override $BracketEntityCopyWith<$Res> get bracket;

}
/// @nodoc
class __$BracketGenerationResultCopyWithImpl<$Res>
    implements _$BracketGenerationResultCopyWith<$Res> {
  __$BracketGenerationResultCopyWithImpl(this._self, this._then);

  final _BracketGenerationResult _self;
  final $Res Function(_BracketGenerationResult) _then;

/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bracket = null,Object? matches = null,}) {
  return _then(_BracketGenerationResult(
bracket: null == bracket ? _self.bracket : bracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<MatchEntity>,
  ));
}

/// Create a copy of BracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get bracket {
  
  return $BracketEntityCopyWith<$Res>(_self.bracket, (value) {
    return _then(_self.copyWith(bracket: value));
  });
}
}

// dart format on
