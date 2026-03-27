// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentEntity {

/// Globally unique identifier (UUID v4).
 String get id;/// Human-readable name shown across all screens and bracket headers.
 String get name; String get dateRange; String get venue; String get organizer;/// URL of the left-side logo displayed in the tie sheet header.
/// Defaults to India Taekwondo federation logo.
 String get rightLogoUrl;/// URL of the right-side logo displayed in the tie sheet header.
/// Defaults to World Taekwondo federation logo.
 String get leftLogoUrl;/// Wall-clock time when this tournament was first created in-memory.
 DateTime get createdAt;
/// Create a copy of TournamentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentEntityCopyWith<TournamentEntity> get copyWith => _$TournamentEntityCopyWithImpl<TournamentEntity>(this as TournamentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.rightLogoUrl, rightLogoUrl) || other.rightLogoUrl == rightLogoUrl)&&(identical(other.leftLogoUrl, leftLogoUrl) || other.leftLogoUrl == leftLogoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dateRange,venue,organizer,rightLogoUrl,leftLogoUrl,createdAt);

@override
String toString() {
  return 'TournamentEntity(id: $id, name: $name, dateRange: $dateRange, venue: $venue, organizer: $organizer, rightLogoUrl: $rightLogoUrl, leftLogoUrl: $leftLogoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TournamentEntityCopyWith<$Res>  {
  factory $TournamentEntityCopyWith(TournamentEntity value, $Res Function(TournamentEntity) _then) = _$TournamentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String dateRange, String venue, String organizer, String rightLogoUrl, String leftLogoUrl, DateTime createdAt
});




}
/// @nodoc
class _$TournamentEntityCopyWithImpl<$Res>
    implements $TournamentEntityCopyWith<$Res> {
  _$TournamentEntityCopyWithImpl(this._self, this._then);

  final TournamentEntity _self;
  final $Res Function(TournamentEntity) _then;

/// Create a copy of TournamentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dateRange = null,Object? venue = null,Object? organizer = null,Object? rightLogoUrl = null,Object? leftLogoUrl = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as String,rightLogoUrl: null == rightLogoUrl ? _self.rightLogoUrl : rightLogoUrl // ignore: cast_nullable_to_non_nullable
as String,leftLogoUrl: null == leftLogoUrl ? _self.leftLogoUrl : leftLogoUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentEntity].
extension TournamentEntityPatterns on TournamentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentEntity value)  $default,){
final _that = this;
switch (_that) {
case _TournamentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String dateRange,  String venue,  String organizer,  String rightLogoUrl,  String leftLogoUrl,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentEntity() when $default != null:
return $default(_that.id,_that.name,_that.dateRange,_that.venue,_that.organizer,_that.rightLogoUrl,_that.leftLogoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String dateRange,  String venue,  String organizer,  String rightLogoUrl,  String leftLogoUrl,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TournamentEntity():
return $default(_that.id,_that.name,_that.dateRange,_that.venue,_that.organizer,_that.rightLogoUrl,_that.leftLogoUrl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String dateRange,  String venue,  String organizer,  String rightLogoUrl,  String leftLogoUrl,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TournamentEntity() when $default != null:
return $default(_that.id,_that.name,_that.dateRange,_that.venue,_that.organizer,_that.rightLogoUrl,_that.leftLogoUrl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TournamentEntity implements TournamentEntity {
  const _TournamentEntity({required this.id, required this.name, this.dateRange = '', this.venue = '', this.organizer = '', this.rightLogoUrl = 'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/India_Taekwondo_logo_5346.png', this.leftLogoUrl = 'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/World_Taekwondo+logo_356345.png', required this.createdAt});
  

/// Globally unique identifier (UUID v4).
@override final  String id;
/// Human-readable name shown across all screens and bracket headers.
@override final  String name;
@override@JsonKey() final  String dateRange;
@override@JsonKey() final  String venue;
@override@JsonKey() final  String organizer;
/// URL of the left-side logo displayed in the tie sheet header.
/// Defaults to India Taekwondo federation logo.
@override@JsonKey() final  String rightLogoUrl;
/// URL of the right-side logo displayed in the tie sheet header.
/// Defaults to World Taekwondo federation logo.
@override@JsonKey() final  String leftLogoUrl;
/// Wall-clock time when this tournament was first created in-memory.
@override final  DateTime createdAt;

/// Create a copy of TournamentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentEntityCopyWith<_TournamentEntity> get copyWith => __$TournamentEntityCopyWithImpl<_TournamentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.rightLogoUrl, rightLogoUrl) || other.rightLogoUrl == rightLogoUrl)&&(identical(other.leftLogoUrl, leftLogoUrl) || other.leftLogoUrl == leftLogoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dateRange,venue,organizer,rightLogoUrl,leftLogoUrl,createdAt);

@override
String toString() {
  return 'TournamentEntity(id: $id, name: $name, dateRange: $dateRange, venue: $venue, organizer: $organizer, rightLogoUrl: $rightLogoUrl, leftLogoUrl: $leftLogoUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TournamentEntityCopyWith<$Res> implements $TournamentEntityCopyWith<$Res> {
  factory _$TournamentEntityCopyWith(_TournamentEntity value, $Res Function(_TournamentEntity) _then) = __$TournamentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String dateRange, String venue, String organizer, String rightLogoUrl, String leftLogoUrl, DateTime createdAt
});




}
/// @nodoc
class __$TournamentEntityCopyWithImpl<$Res>
    implements _$TournamentEntityCopyWith<$Res> {
  __$TournamentEntityCopyWithImpl(this._self, this._then);

  final _TournamentEntity _self;
  final $Res Function(_TournamentEntity) _then;

/// Create a copy of TournamentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dateRange = null,Object? venue = null,Object? organizer = null,Object? rightLogoUrl = null,Object? leftLogoUrl = null,Object? createdAt = null,}) {
  return _then(_TournamentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as String,rightLogoUrl: null == rightLogoUrl ? _self.rightLogoUrl : rightLogoUrl // ignore: cast_nullable_to_non_nullable
as String,leftLogoUrl: null == leftLogoUrl ? _self.leftLogoUrl : leftLogoUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
