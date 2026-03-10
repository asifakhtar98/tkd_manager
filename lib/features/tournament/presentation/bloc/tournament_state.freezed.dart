// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentState {

 List<TournamentEntity> get tournaments; Map<String, List<BracketSnapshot>> get bracketsByTournamentId;
/// Create a copy of TournamentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentStateCopyWith<TournamentState> get copyWith => _$TournamentStateCopyWithImpl<TournamentState>(this as TournamentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentState&&const DeepCollectionEquality().equals(other.tournaments, tournaments)&&const DeepCollectionEquality().equals(other.bracketsByTournamentId, bracketsByTournamentId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tournaments),const DeepCollectionEquality().hash(bracketsByTournamentId));

@override
String toString() {
  return 'TournamentState(tournaments: $tournaments, bracketsByTournamentId: $bracketsByTournamentId)';
}


}

/// @nodoc
abstract mixin class $TournamentStateCopyWith<$Res>  {
  factory $TournamentStateCopyWith(TournamentState value, $Res Function(TournamentState) _then) = _$TournamentStateCopyWithImpl;
@useResult
$Res call({
 List<TournamentEntity> tournaments, Map<String, List<BracketSnapshot>> bracketsByTournamentId
});




}
/// @nodoc
class _$TournamentStateCopyWithImpl<$Res>
    implements $TournamentStateCopyWith<$Res> {
  _$TournamentStateCopyWithImpl(this._self, this._then);

  final TournamentState _self;
  final $Res Function(TournamentState) _then;

/// Create a copy of TournamentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tournaments = null,Object? bracketsByTournamentId = null,}) {
  return _then(_self.copyWith(
tournaments: null == tournaments ? _self.tournaments : tournaments // ignore: cast_nullable_to_non_nullable
as List<TournamentEntity>,bracketsByTournamentId: null == bracketsByTournamentId ? _self.bracketsByTournamentId : bracketsByTournamentId // ignore: cast_nullable_to_non_nullable
as Map<String, List<BracketSnapshot>>,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentState].
extension TournamentStatePatterns on TournamentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentState value)  $default,){
final _that = this;
switch (_that) {
case _TournamentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentState value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TournamentEntity> tournaments,  Map<String, List<BracketSnapshot>> bracketsByTournamentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentState() when $default != null:
return $default(_that.tournaments,_that.bracketsByTournamentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TournamentEntity> tournaments,  Map<String, List<BracketSnapshot>> bracketsByTournamentId)  $default,) {final _that = this;
switch (_that) {
case _TournamentState():
return $default(_that.tournaments,_that.bracketsByTournamentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TournamentEntity> tournaments,  Map<String, List<BracketSnapshot>> bracketsByTournamentId)?  $default,) {final _that = this;
switch (_that) {
case _TournamentState() when $default != null:
return $default(_that.tournaments,_that.bracketsByTournamentId);case _:
  return null;

}
}

}

/// @nodoc


class _TournamentState extends TournamentState {
  const _TournamentState({final  List<TournamentEntity> tournaments = const [], final  Map<String, List<BracketSnapshot>> bracketsByTournamentId = const {}}): _tournaments = tournaments,_bracketsByTournamentId = bracketsByTournamentId,super._();
  

 final  List<TournamentEntity> _tournaments;
@override@JsonKey() List<TournamentEntity> get tournaments {
  if (_tournaments is EqualUnmodifiableListView) return _tournaments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tournaments);
}

 final  Map<String, List<BracketSnapshot>> _bracketsByTournamentId;
@override@JsonKey() Map<String, List<BracketSnapshot>> get bracketsByTournamentId {
  if (_bracketsByTournamentId is EqualUnmodifiableMapView) return _bracketsByTournamentId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bracketsByTournamentId);
}


/// Create a copy of TournamentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentStateCopyWith<_TournamentState> get copyWith => __$TournamentStateCopyWithImpl<_TournamentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentState&&const DeepCollectionEquality().equals(other._tournaments, _tournaments)&&const DeepCollectionEquality().equals(other._bracketsByTournamentId, _bracketsByTournamentId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tournaments),const DeepCollectionEquality().hash(_bracketsByTournamentId));

@override
String toString() {
  return 'TournamentState(tournaments: $tournaments, bracketsByTournamentId: $bracketsByTournamentId)';
}


}

/// @nodoc
abstract mixin class _$TournamentStateCopyWith<$Res> implements $TournamentStateCopyWith<$Res> {
  factory _$TournamentStateCopyWith(_TournamentState value, $Res Function(_TournamentState) _then) = __$TournamentStateCopyWithImpl;
@override @useResult
$Res call({
 List<TournamentEntity> tournaments, Map<String, List<BracketSnapshot>> bracketsByTournamentId
});




}
/// @nodoc
class __$TournamentStateCopyWithImpl<$Res>
    implements _$TournamentStateCopyWith<$Res> {
  __$TournamentStateCopyWithImpl(this._self, this._then);

  final _TournamentState _self;
  final $Res Function(_TournamentState) _then;

/// Create a copy of TournamentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tournaments = null,Object? bracketsByTournamentId = null,}) {
  return _then(_TournamentState(
tournaments: null == tournaments ? _self._tournaments : tournaments // ignore: cast_nullable_to_non_nullable
as List<TournamentEntity>,bracketsByTournamentId: null == bracketsByTournamentId ? _self._bracketsByTournamentId : bracketsByTournamentId // ignore: cast_nullable_to_non_nullable
as Map<String, List<BracketSnapshot>>,
  ));
}


}

// dart format on
