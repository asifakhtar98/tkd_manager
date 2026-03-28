// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TournamentEvent()';
}


}

/// @nodoc
class $TournamentEventCopyWith<$Res>  {
$TournamentEventCopyWith(TournamentEvent _, $Res Function(TournamentEvent) __);
}


/// Adds pattern-matching-related methods to [TournamentEvent].
extension TournamentEventPatterns on TournamentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TournamentCreated value)?  created,TResult Function( TournamentBracketSnapshotAdded value)?  bracketSnapshotAdded,TResult Function( TournamentBracketSnapshotRemoved value)?  bracketSnapshotRemoved,TResult Function( TournamentDeleted value)?  deleted,TResult Function( TournamentUpdated value)?  updated,TResult Function( TournamentBracketSnapshotUpdated value)?  bracketSnapshotUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TournamentCreated() when created != null:
return created(_that);case TournamentBracketSnapshotAdded() when bracketSnapshotAdded != null:
return bracketSnapshotAdded(_that);case TournamentBracketSnapshotRemoved() when bracketSnapshotRemoved != null:
return bracketSnapshotRemoved(_that);case TournamentDeleted() when deleted != null:
return deleted(_that);case TournamentUpdated() when updated != null:
return updated(_that);case TournamentBracketSnapshotUpdated() when bracketSnapshotUpdated != null:
return bracketSnapshotUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TournamentCreated value)  created,required TResult Function( TournamentBracketSnapshotAdded value)  bracketSnapshotAdded,required TResult Function( TournamentBracketSnapshotRemoved value)  bracketSnapshotRemoved,required TResult Function( TournamentDeleted value)  deleted,required TResult Function( TournamentUpdated value)  updated,required TResult Function( TournamentBracketSnapshotUpdated value)  bracketSnapshotUpdated,}){
final _that = this;
switch (_that) {
case TournamentCreated():
return created(_that);case TournamentBracketSnapshotAdded():
return bracketSnapshotAdded(_that);case TournamentBracketSnapshotRemoved():
return bracketSnapshotRemoved(_that);case TournamentDeleted():
return deleted(_that);case TournamentUpdated():
return updated(_that);case TournamentBracketSnapshotUpdated():
return bracketSnapshotUpdated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TournamentCreated value)?  created,TResult? Function( TournamentBracketSnapshotAdded value)?  bracketSnapshotAdded,TResult? Function( TournamentBracketSnapshotRemoved value)?  bracketSnapshotRemoved,TResult? Function( TournamentDeleted value)?  deleted,TResult? Function( TournamentUpdated value)?  updated,TResult? Function( TournamentBracketSnapshotUpdated value)?  bracketSnapshotUpdated,}){
final _that = this;
switch (_that) {
case TournamentCreated() when created != null:
return created(_that);case TournamentBracketSnapshotAdded() when bracketSnapshotAdded != null:
return bracketSnapshotAdded(_that);case TournamentBracketSnapshotRemoved() when bracketSnapshotRemoved != null:
return bracketSnapshotRemoved(_that);case TournamentDeleted() when deleted != null:
return deleted(_that);case TournamentUpdated() when updated != null:
return updated(_that);case TournamentBracketSnapshotUpdated() when bracketSnapshotUpdated != null:
return bracketSnapshotUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TournamentEntity tournament)?  created,TResult Function( String tournamentId,  BracketSnapshot snapshot)?  bracketSnapshotAdded,TResult Function( String tournamentId,  String snapshotId)?  bracketSnapshotRemoved,TResult Function( String tournamentId)?  deleted,TResult Function( TournamentEntity tournament)?  updated,TResult Function( BracketSnapshot snapshot)?  bracketSnapshotUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TournamentCreated() when created != null:
return created(_that.tournament);case TournamentBracketSnapshotAdded() when bracketSnapshotAdded != null:
return bracketSnapshotAdded(_that.tournamentId,_that.snapshot);case TournamentBracketSnapshotRemoved() when bracketSnapshotRemoved != null:
return bracketSnapshotRemoved(_that.tournamentId,_that.snapshotId);case TournamentDeleted() when deleted != null:
return deleted(_that.tournamentId);case TournamentUpdated() when updated != null:
return updated(_that.tournament);case TournamentBracketSnapshotUpdated() when bracketSnapshotUpdated != null:
return bracketSnapshotUpdated(_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TournamentEntity tournament)  created,required TResult Function( String tournamentId,  BracketSnapshot snapshot)  bracketSnapshotAdded,required TResult Function( String tournamentId,  String snapshotId)  bracketSnapshotRemoved,required TResult Function( String tournamentId)  deleted,required TResult Function( TournamentEntity tournament)  updated,required TResult Function( BracketSnapshot snapshot)  bracketSnapshotUpdated,}) {final _that = this;
switch (_that) {
case TournamentCreated():
return created(_that.tournament);case TournamentBracketSnapshotAdded():
return bracketSnapshotAdded(_that.tournamentId,_that.snapshot);case TournamentBracketSnapshotRemoved():
return bracketSnapshotRemoved(_that.tournamentId,_that.snapshotId);case TournamentDeleted():
return deleted(_that.tournamentId);case TournamentUpdated():
return updated(_that.tournament);case TournamentBracketSnapshotUpdated():
return bracketSnapshotUpdated(_that.snapshot);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TournamentEntity tournament)?  created,TResult? Function( String tournamentId,  BracketSnapshot snapshot)?  bracketSnapshotAdded,TResult? Function( String tournamentId,  String snapshotId)?  bracketSnapshotRemoved,TResult? Function( String tournamentId)?  deleted,TResult? Function( TournamentEntity tournament)?  updated,TResult? Function( BracketSnapshot snapshot)?  bracketSnapshotUpdated,}) {final _that = this;
switch (_that) {
case TournamentCreated() when created != null:
return created(_that.tournament);case TournamentBracketSnapshotAdded() when bracketSnapshotAdded != null:
return bracketSnapshotAdded(_that.tournamentId,_that.snapshot);case TournamentBracketSnapshotRemoved() when bracketSnapshotRemoved != null:
return bracketSnapshotRemoved(_that.tournamentId,_that.snapshotId);case TournamentDeleted() when deleted != null:
return deleted(_that.tournamentId);case TournamentUpdated() when updated != null:
return updated(_that.tournament);case TournamentBracketSnapshotUpdated() when bracketSnapshotUpdated != null:
return bracketSnapshotUpdated(_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc


class TournamentCreated implements TournamentEvent {
  const TournamentCreated(this.tournament);
  

 final  TournamentEntity tournament;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentCreatedCopyWith<TournamentCreated> get copyWith => _$TournamentCreatedCopyWithImpl<TournamentCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentCreated&&(identical(other.tournament, tournament) || other.tournament == tournament));
}


@override
int get hashCode => Object.hash(runtimeType,tournament);

@override
String toString() {
  return 'TournamentEvent.created(tournament: $tournament)';
}


}

/// @nodoc
abstract mixin class $TournamentCreatedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentCreatedCopyWith(TournamentCreated value, $Res Function(TournamentCreated) _then) = _$TournamentCreatedCopyWithImpl;
@useResult
$Res call({
 TournamentEntity tournament
});


$TournamentEntityCopyWith<$Res> get tournament;

}
/// @nodoc
class _$TournamentCreatedCopyWithImpl<$Res>
    implements $TournamentCreatedCopyWith<$Res> {
  _$TournamentCreatedCopyWithImpl(this._self, this._then);

  final TournamentCreated _self;
  final $Res Function(TournamentCreated) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tournament = null,}) {
  return _then(TournamentCreated(
null == tournament ? _self.tournament : tournament // ignore: cast_nullable_to_non_nullable
as TournamentEntity,
  ));
}

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TournamentEntityCopyWith<$Res> get tournament {
  
  return $TournamentEntityCopyWith<$Res>(_self.tournament, (value) {
    return _then(_self.copyWith(tournament: value));
  });
}
}

/// @nodoc


class TournamentBracketSnapshotAdded implements TournamentEvent {
  const TournamentBracketSnapshotAdded({required this.tournamentId, required this.snapshot});
  

 final  String tournamentId;
 final  BracketSnapshot snapshot;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentBracketSnapshotAddedCopyWith<TournamentBracketSnapshotAdded> get copyWith => _$TournamentBracketSnapshotAddedCopyWithImpl<TournamentBracketSnapshotAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentBracketSnapshotAdded&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,tournamentId,snapshot);

@override
String toString() {
  return 'TournamentEvent.bracketSnapshotAdded(tournamentId: $tournamentId, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $TournamentBracketSnapshotAddedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentBracketSnapshotAddedCopyWith(TournamentBracketSnapshotAdded value, $Res Function(TournamentBracketSnapshotAdded) _then) = _$TournamentBracketSnapshotAddedCopyWithImpl;
@useResult
$Res call({
 String tournamentId, BracketSnapshot snapshot
});


$BracketSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$TournamentBracketSnapshotAddedCopyWithImpl<$Res>
    implements $TournamentBracketSnapshotAddedCopyWith<$Res> {
  _$TournamentBracketSnapshotAddedCopyWithImpl(this._self, this._then);

  final TournamentBracketSnapshotAdded _self;
  final $Res Function(TournamentBracketSnapshotAdded) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? snapshot = null,}) {
  return _then(TournamentBracketSnapshotAdded(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as BracketSnapshot,
  ));
}

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketSnapshotCopyWith<$Res> get snapshot {
  
  return $BracketSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

/// @nodoc


class TournamentBracketSnapshotRemoved implements TournamentEvent {
  const TournamentBracketSnapshotRemoved({required this.tournamentId, required this.snapshotId});
  

 final  String tournamentId;
 final  String snapshotId;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentBracketSnapshotRemovedCopyWith<TournamentBracketSnapshotRemoved> get copyWith => _$TournamentBracketSnapshotRemovedCopyWithImpl<TournamentBracketSnapshotRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentBracketSnapshotRemoved&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.snapshotId, snapshotId) || other.snapshotId == snapshotId));
}


@override
int get hashCode => Object.hash(runtimeType,tournamentId,snapshotId);

@override
String toString() {
  return 'TournamentEvent.bracketSnapshotRemoved(tournamentId: $tournamentId, snapshotId: $snapshotId)';
}


}

/// @nodoc
abstract mixin class $TournamentBracketSnapshotRemovedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentBracketSnapshotRemovedCopyWith(TournamentBracketSnapshotRemoved value, $Res Function(TournamentBracketSnapshotRemoved) _then) = _$TournamentBracketSnapshotRemovedCopyWithImpl;
@useResult
$Res call({
 String tournamentId, String snapshotId
});




}
/// @nodoc
class _$TournamentBracketSnapshotRemovedCopyWithImpl<$Res>
    implements $TournamentBracketSnapshotRemovedCopyWith<$Res> {
  _$TournamentBracketSnapshotRemovedCopyWithImpl(this._self, this._then);

  final TournamentBracketSnapshotRemoved _self;
  final $Res Function(TournamentBracketSnapshotRemoved) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? snapshotId = null,}) {
  return _then(TournamentBracketSnapshotRemoved(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,snapshotId: null == snapshotId ? _self.snapshotId : snapshotId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TournamentDeleted implements TournamentEvent {
  const TournamentDeleted(this.tournamentId);
  

 final  String tournamentId;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentDeletedCopyWith<TournamentDeleted> get copyWith => _$TournamentDeletedCopyWithImpl<TournamentDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentDeleted&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId));
}


@override
int get hashCode => Object.hash(runtimeType,tournamentId);

@override
String toString() {
  return 'TournamentEvent.deleted(tournamentId: $tournamentId)';
}


}

/// @nodoc
abstract mixin class $TournamentDeletedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentDeletedCopyWith(TournamentDeleted value, $Res Function(TournamentDeleted) _then) = _$TournamentDeletedCopyWithImpl;
@useResult
$Res call({
 String tournamentId
});




}
/// @nodoc
class _$TournamentDeletedCopyWithImpl<$Res>
    implements $TournamentDeletedCopyWith<$Res> {
  _$TournamentDeletedCopyWithImpl(this._self, this._then);

  final TournamentDeleted _self;
  final $Res Function(TournamentDeleted) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,}) {
  return _then(TournamentDeleted(
null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TournamentUpdated implements TournamentEvent {
  const TournamentUpdated(this.tournament);
  

 final  TournamentEntity tournament;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentUpdatedCopyWith<TournamentUpdated> get copyWith => _$TournamentUpdatedCopyWithImpl<TournamentUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentUpdated&&(identical(other.tournament, tournament) || other.tournament == tournament));
}


@override
int get hashCode => Object.hash(runtimeType,tournament);

@override
String toString() {
  return 'TournamentEvent.updated(tournament: $tournament)';
}


}

/// @nodoc
abstract mixin class $TournamentUpdatedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentUpdatedCopyWith(TournamentUpdated value, $Res Function(TournamentUpdated) _then) = _$TournamentUpdatedCopyWithImpl;
@useResult
$Res call({
 TournamentEntity tournament
});


$TournamentEntityCopyWith<$Res> get tournament;

}
/// @nodoc
class _$TournamentUpdatedCopyWithImpl<$Res>
    implements $TournamentUpdatedCopyWith<$Res> {
  _$TournamentUpdatedCopyWithImpl(this._self, this._then);

  final TournamentUpdated _self;
  final $Res Function(TournamentUpdated) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tournament = null,}) {
  return _then(TournamentUpdated(
null == tournament ? _self.tournament : tournament // ignore: cast_nullable_to_non_nullable
as TournamentEntity,
  ));
}

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TournamentEntityCopyWith<$Res> get tournament {
  
  return $TournamentEntityCopyWith<$Res>(_self.tournament, (value) {
    return _then(_self.copyWith(tournament: value));
  });
}
}

/// @nodoc


class TournamentBracketSnapshotUpdated implements TournamentEvent {
  const TournamentBracketSnapshotUpdated(this.snapshot);
  

 final  BracketSnapshot snapshot;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentBracketSnapshotUpdatedCopyWith<TournamentBracketSnapshotUpdated> get copyWith => _$TournamentBracketSnapshotUpdatedCopyWithImpl<TournamentBracketSnapshotUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentBracketSnapshotUpdated&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot);

@override
String toString() {
  return 'TournamentEvent.bracketSnapshotUpdated(snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $TournamentBracketSnapshotUpdatedCopyWith<$Res> implements $TournamentEventCopyWith<$Res> {
  factory $TournamentBracketSnapshotUpdatedCopyWith(TournamentBracketSnapshotUpdated value, $Res Function(TournamentBracketSnapshotUpdated) _then) = _$TournamentBracketSnapshotUpdatedCopyWithImpl;
@useResult
$Res call({
 BracketSnapshot snapshot
});


$BracketSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$TournamentBracketSnapshotUpdatedCopyWithImpl<$Res>
    implements $TournamentBracketSnapshotUpdatedCopyWith<$Res> {
  _$TournamentBracketSnapshotUpdatedCopyWithImpl(this._self, this._then);

  final TournamentBracketSnapshotUpdated _self;
  final $Res Function(TournamentBracketSnapshotUpdated) _then;

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snapshot = null,}) {
  return _then(TournamentBracketSnapshotUpdated(
null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as BracketSnapshot,
  ));
}

/// Create a copy of TournamentEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketSnapshotCopyWith<$Res> get snapshot {
  
  return $BracketSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

// dart format on
