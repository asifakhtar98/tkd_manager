// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'double_elimination_bracket_generation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoubleEliminationBracketGenerationResult {

 BracketEntity get winnersBracket; BracketEntity get losersBracket; MatchEntity get grandFinalsMatch; MatchEntity? get resetMatch; List<MatchEntity> get allMatches;
/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoubleEliminationBracketGenerationResultCopyWith<DoubleEliminationBracketGenerationResult> get copyWith => _$DoubleEliminationBracketGenerationResultCopyWithImpl<DoubleEliminationBracketGenerationResult>(this as DoubleEliminationBracketGenerationResult, _$identity);

  /// Serializes this DoubleEliminationBracketGenerationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoubleEliminationBracketGenerationResult&&(identical(other.winnersBracket, winnersBracket) || other.winnersBracket == winnersBracket)&&(identical(other.losersBracket, losersBracket) || other.losersBracket == losersBracket)&&(identical(other.grandFinalsMatch, grandFinalsMatch) || other.grandFinalsMatch == grandFinalsMatch)&&(identical(other.resetMatch, resetMatch) || other.resetMatch == resetMatch)&&const DeepCollectionEquality().equals(other.allMatches, allMatches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,winnersBracket,losersBracket,grandFinalsMatch,resetMatch,const DeepCollectionEquality().hash(allMatches));

@override
String toString() {
  return 'DoubleEliminationBracketGenerationResult(winnersBracket: $winnersBracket, losersBracket: $losersBracket, grandFinalsMatch: $grandFinalsMatch, resetMatch: $resetMatch, allMatches: $allMatches)';
}


}

/// @nodoc
abstract mixin class $DoubleEliminationBracketGenerationResultCopyWith<$Res>  {
  factory $DoubleEliminationBracketGenerationResultCopyWith(DoubleEliminationBracketGenerationResult value, $Res Function(DoubleEliminationBracketGenerationResult) _then) = _$DoubleEliminationBracketGenerationResultCopyWithImpl;
@useResult
$Res call({
 BracketEntity winnersBracket, BracketEntity losersBracket, MatchEntity grandFinalsMatch, MatchEntity? resetMatch, List<MatchEntity> allMatches
});


$BracketEntityCopyWith<$Res> get winnersBracket;$BracketEntityCopyWith<$Res> get losersBracket;$MatchEntityCopyWith<$Res> get grandFinalsMatch;$MatchEntityCopyWith<$Res>? get resetMatch;

}
/// @nodoc
class _$DoubleEliminationBracketGenerationResultCopyWithImpl<$Res>
    implements $DoubleEliminationBracketGenerationResultCopyWith<$Res> {
  _$DoubleEliminationBracketGenerationResultCopyWithImpl(this._self, this._then);

  final DoubleEliminationBracketGenerationResult _self;
  final $Res Function(DoubleEliminationBracketGenerationResult) _then;

/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? winnersBracket = null,Object? losersBracket = null,Object? grandFinalsMatch = null,Object? resetMatch = freezed,Object? allMatches = null,}) {
  return _then(_self.copyWith(
winnersBracket: null == winnersBracket ? _self.winnersBracket : winnersBracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,losersBracket: null == losersBracket ? _self.losersBracket : losersBracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,grandFinalsMatch: null == grandFinalsMatch ? _self.grandFinalsMatch : grandFinalsMatch // ignore: cast_nullable_to_non_nullable
as MatchEntity,resetMatch: freezed == resetMatch ? _self.resetMatch : resetMatch // ignore: cast_nullable_to_non_nullable
as MatchEntity?,allMatches: null == allMatches ? _self.allMatches : allMatches // ignore: cast_nullable_to_non_nullable
as List<MatchEntity>,
  ));
}
/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get winnersBracket {
  
  return $BracketEntityCopyWith<$Res>(_self.winnersBracket, (value) {
    return _then(_self.copyWith(winnersBracket: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get losersBracket {
  
  return $BracketEntityCopyWith<$Res>(_self.losersBracket, (value) {
    return _then(_self.copyWith(losersBracket: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchEntityCopyWith<$Res> get grandFinalsMatch {
  
  return $MatchEntityCopyWith<$Res>(_self.grandFinalsMatch, (value) {
    return _then(_self.copyWith(grandFinalsMatch: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchEntityCopyWith<$Res>? get resetMatch {
    if (_self.resetMatch == null) {
    return null;
  }

  return $MatchEntityCopyWith<$Res>(_self.resetMatch!, (value) {
    return _then(_self.copyWith(resetMatch: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoubleEliminationBracketGenerationResult].
extension DoubleEliminationBracketGenerationResultPatterns on DoubleEliminationBracketGenerationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoubleEliminationBracketGenerationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoubleEliminationBracketGenerationResult value)  $default,){
final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoubleEliminationBracketGenerationResult value)?  $default,){
final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BracketEntity winnersBracket,  BracketEntity losersBracket,  MatchEntity grandFinalsMatch,  MatchEntity? resetMatch,  List<MatchEntity> allMatches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult() when $default != null:
return $default(_that.winnersBracket,_that.losersBracket,_that.grandFinalsMatch,_that.resetMatch,_that.allMatches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BracketEntity winnersBracket,  BracketEntity losersBracket,  MatchEntity grandFinalsMatch,  MatchEntity? resetMatch,  List<MatchEntity> allMatches)  $default,) {final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult():
return $default(_that.winnersBracket,_that.losersBracket,_that.grandFinalsMatch,_that.resetMatch,_that.allMatches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BracketEntity winnersBracket,  BracketEntity losersBracket,  MatchEntity grandFinalsMatch,  MatchEntity? resetMatch,  List<MatchEntity> allMatches)?  $default,) {final _that = this;
switch (_that) {
case _DoubleEliminationBracketGenerationResult() when $default != null:
return $default(_that.winnersBracket,_that.losersBracket,_that.grandFinalsMatch,_that.resetMatch,_that.allMatches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoubleEliminationBracketGenerationResult implements DoubleEliminationBracketGenerationResult {
  const _DoubleEliminationBracketGenerationResult({required this.winnersBracket, required this.losersBracket, required this.grandFinalsMatch, this.resetMatch, required final  List<MatchEntity> allMatches}): _allMatches = allMatches;
  factory _DoubleEliminationBracketGenerationResult.fromJson(Map<String, dynamic> json) => _$DoubleEliminationBracketGenerationResultFromJson(json);

@override final  BracketEntity winnersBracket;
@override final  BracketEntity losersBracket;
@override final  MatchEntity grandFinalsMatch;
@override final  MatchEntity? resetMatch;
 final  List<MatchEntity> _allMatches;
@override List<MatchEntity> get allMatches {
  if (_allMatches is EqualUnmodifiableListView) return _allMatches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allMatches);
}


/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoubleEliminationBracketGenerationResultCopyWith<_DoubleEliminationBracketGenerationResult> get copyWith => __$DoubleEliminationBracketGenerationResultCopyWithImpl<_DoubleEliminationBracketGenerationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoubleEliminationBracketGenerationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoubleEliminationBracketGenerationResult&&(identical(other.winnersBracket, winnersBracket) || other.winnersBracket == winnersBracket)&&(identical(other.losersBracket, losersBracket) || other.losersBracket == losersBracket)&&(identical(other.grandFinalsMatch, grandFinalsMatch) || other.grandFinalsMatch == grandFinalsMatch)&&(identical(other.resetMatch, resetMatch) || other.resetMatch == resetMatch)&&const DeepCollectionEquality().equals(other._allMatches, _allMatches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,winnersBracket,losersBracket,grandFinalsMatch,resetMatch,const DeepCollectionEquality().hash(_allMatches));

@override
String toString() {
  return 'DoubleEliminationBracketGenerationResult(winnersBracket: $winnersBracket, losersBracket: $losersBracket, grandFinalsMatch: $grandFinalsMatch, resetMatch: $resetMatch, allMatches: $allMatches)';
}


}

/// @nodoc
abstract mixin class _$DoubleEliminationBracketGenerationResultCopyWith<$Res> implements $DoubleEliminationBracketGenerationResultCopyWith<$Res> {
  factory _$DoubleEliminationBracketGenerationResultCopyWith(_DoubleEliminationBracketGenerationResult value, $Res Function(_DoubleEliminationBracketGenerationResult) _then) = __$DoubleEliminationBracketGenerationResultCopyWithImpl;
@override @useResult
$Res call({
 BracketEntity winnersBracket, BracketEntity losersBracket, MatchEntity grandFinalsMatch, MatchEntity? resetMatch, List<MatchEntity> allMatches
});


@override $BracketEntityCopyWith<$Res> get winnersBracket;@override $BracketEntityCopyWith<$Res> get losersBracket;@override $MatchEntityCopyWith<$Res> get grandFinalsMatch;@override $MatchEntityCopyWith<$Res>? get resetMatch;

}
/// @nodoc
class __$DoubleEliminationBracketGenerationResultCopyWithImpl<$Res>
    implements _$DoubleEliminationBracketGenerationResultCopyWith<$Res> {
  __$DoubleEliminationBracketGenerationResultCopyWithImpl(this._self, this._then);

  final _DoubleEliminationBracketGenerationResult _self;
  final $Res Function(_DoubleEliminationBracketGenerationResult) _then;

/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? winnersBracket = null,Object? losersBracket = null,Object? grandFinalsMatch = null,Object? resetMatch = freezed,Object? allMatches = null,}) {
  return _then(_DoubleEliminationBracketGenerationResult(
winnersBracket: null == winnersBracket ? _self.winnersBracket : winnersBracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,losersBracket: null == losersBracket ? _self.losersBracket : losersBracket // ignore: cast_nullable_to_non_nullable
as BracketEntity,grandFinalsMatch: null == grandFinalsMatch ? _self.grandFinalsMatch : grandFinalsMatch // ignore: cast_nullable_to_non_nullable
as MatchEntity,resetMatch: freezed == resetMatch ? _self.resetMatch : resetMatch // ignore: cast_nullable_to_non_nullable
as MatchEntity?,allMatches: null == allMatches ? _self._allMatches : allMatches // ignore: cast_nullable_to_non_nullable
as List<MatchEntity>,
  ));
}

/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get winnersBracket {
  
  return $BracketEntityCopyWith<$Res>(_self.winnersBracket, (value) {
    return _then(_self.copyWith(winnersBracket: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketEntityCopyWith<$Res> get losersBracket {
  
  return $BracketEntityCopyWith<$Res>(_self.losersBracket, (value) {
    return _then(_self.copyWith(losersBracket: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchEntityCopyWith<$Res> get grandFinalsMatch {
  
  return $MatchEntityCopyWith<$Res>(_self.grandFinalsMatch, (value) {
    return _then(_self.copyWith(grandFinalsMatch: value));
  });
}/// Create a copy of DoubleEliminationBracketGenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchEntityCopyWith<$Res>? get resetMatch {
    if (_self.resetMatch == null) {
    return null;
  }

  return $MatchEntityCopyWith<$Res>(_self.resetMatch!, (value) {
    return _then(_self.copyWith(resetMatch: value));
  });
}
}

// dart format on
