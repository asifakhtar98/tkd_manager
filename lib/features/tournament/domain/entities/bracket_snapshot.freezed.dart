// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketSnapshot {

/// Unique ID for this snapshot (UUID v4).
 String get id;/// Display label, e.g. "Single Elim — 8 Players".
 String get label;/// The elimination format used for this bracket generation.
 BracketFormat get format; int get participantCount; bool get includeThirdPlaceMatch; bool get dojangSeparation;/// Wall-clock time when the bracket was generated.
 DateTime get generatedAt;/// Full participant list at the time of generation.
 List<ParticipantEntity> get participants;/// The generated bracket data (single or double elimination union).
 BracketResult get result;
/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketSnapshotCopyWith<BracketSnapshot> get copyWith => _$BracketSnapshotCopyWithImpl<BracketSnapshot>(this as BracketSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.format, format) || other.format == format)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.dojangSeparation, dojangSeparation) || other.dojangSeparation == dojangSeparation)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,format,participantCount,includeThirdPlaceMatch,dojangSeparation,generatedAt,const DeepCollectionEquality().hash(participants),result);

@override
String toString() {
  return 'BracketSnapshot(id: $id, label: $label, format: $format, participantCount: $participantCount, includeThirdPlaceMatch: $includeThirdPlaceMatch, dojangSeparation: $dojangSeparation, generatedAt: $generatedAt, participants: $participants, result: $result)';
}


}

/// @nodoc
abstract mixin class $BracketSnapshotCopyWith<$Res>  {
  factory $BracketSnapshotCopyWith(BracketSnapshot value, $Res Function(BracketSnapshot) _then) = _$BracketSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String label, BracketFormat format, int participantCount, bool includeThirdPlaceMatch, bool dojangSeparation, DateTime generatedAt, List<ParticipantEntity> participants, BracketResult result
});


$BracketResultCopyWith<$Res> get result;

}
/// @nodoc
class _$BracketSnapshotCopyWithImpl<$Res>
    implements $BracketSnapshotCopyWith<$Res> {
  _$BracketSnapshotCopyWithImpl(this._self, this._then);

  final BracketSnapshot _self;
  final $Res Function(BracketSnapshot) _then;

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? format = null,Object? participantCount = null,Object? includeThirdPlaceMatch = null,Object? dojangSeparation = null,Object? generatedAt = null,Object? participants = null,Object? result = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,dojangSeparation: null == dojangSeparation ? _self.dojangSeparation : dojangSeparation // ignore: cast_nullable_to_non_nullable
as bool,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,
  ));
}
/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get result {
  
  return $BracketResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketSnapshot].
extension BracketSnapshotPatterns on BracketSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BracketSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
return $default(_that.id,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.generatedAt,_that.participants,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result)  $default,) {final _that = this;
switch (_that) {
case _BracketSnapshot():
return $default(_that.id,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.generatedAt,_that.participants,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  BracketFormat format,  int participantCount,  bool includeThirdPlaceMatch,  bool dojangSeparation,  DateTime generatedAt,  List<ParticipantEntity> participants,  BracketResult result)?  $default,) {final _that = this;
switch (_that) {
case _BracketSnapshot() when $default != null:
return $default(_that.id,_that.label,_that.format,_that.participantCount,_that.includeThirdPlaceMatch,_that.dojangSeparation,_that.generatedAt,_that.participants,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _BracketSnapshot implements BracketSnapshot {
  const _BracketSnapshot({required this.id, required this.label, required this.format, required this.participantCount, required this.includeThirdPlaceMatch, required this.dojangSeparation, required this.generatedAt, required final  List<ParticipantEntity> participants, required this.result}): _participants = participants;
  

/// Unique ID for this snapshot (UUID v4).
@override final  String id;
/// Display label, e.g. "Single Elim — 8 Players".
@override final  String label;
/// The elimination format used for this bracket generation.
@override final  BracketFormat format;
@override final  int participantCount;
@override final  bool includeThirdPlaceMatch;
@override final  bool dojangSeparation;
/// Wall-clock time when the bracket was generated.
@override final  DateTime generatedAt;
/// Full participant list at the time of generation.
 final  List<ParticipantEntity> _participants;
/// Full participant list at the time of generation.
@override List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The generated bracket data (single or double elimination union).
@override final  BracketResult result;

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketSnapshotCopyWith<_BracketSnapshot> get copyWith => __$BracketSnapshotCopyWithImpl<_BracketSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.format, format) || other.format == format)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.includeThirdPlaceMatch, includeThirdPlaceMatch) || other.includeThirdPlaceMatch == includeThirdPlaceMatch)&&(identical(other.dojangSeparation, dojangSeparation) || other.dojangSeparation == dojangSeparation)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,format,participantCount,includeThirdPlaceMatch,dojangSeparation,generatedAt,const DeepCollectionEquality().hash(_participants),result);

@override
String toString() {
  return 'BracketSnapshot(id: $id, label: $label, format: $format, participantCount: $participantCount, includeThirdPlaceMatch: $includeThirdPlaceMatch, dojangSeparation: $dojangSeparation, generatedAt: $generatedAt, participants: $participants, result: $result)';
}


}

/// @nodoc
abstract mixin class _$BracketSnapshotCopyWith<$Res> implements $BracketSnapshotCopyWith<$Res> {
  factory _$BracketSnapshotCopyWith(_BracketSnapshot value, $Res Function(_BracketSnapshot) _then) = __$BracketSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, BracketFormat format, int participantCount, bool includeThirdPlaceMatch, bool dojangSeparation, DateTime generatedAt, List<ParticipantEntity> participants, BracketResult result
});


@override $BracketResultCopyWith<$Res> get result;

}
/// @nodoc
class __$BracketSnapshotCopyWithImpl<$Res>
    implements _$BracketSnapshotCopyWith<$Res> {
  __$BracketSnapshotCopyWithImpl(this._self, this._then);

  final _BracketSnapshot _self;
  final $Res Function(_BracketSnapshot) _then;

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? format = null,Object? participantCount = null,Object? includeThirdPlaceMatch = null,Object? dojangSeparation = null,Object? generatedAt = null,Object? participants = null,Object? result = null,}) {
  return _then(_BracketSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BracketFormat,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,includeThirdPlaceMatch: null == includeThirdPlaceMatch ? _self.includeThirdPlaceMatch : includeThirdPlaceMatch // ignore: cast_nullable_to_non_nullable
as bool,dojangSeparation: null == dojangSeparation ? _self.dojangSeparation : dojangSeparation // ignore: cast_nullable_to_non_nullable
as bool,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as BracketResult,
  ));
}

/// Create a copy of BracketSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketResultCopyWith<$Res> get result {
  
  return $BracketResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
