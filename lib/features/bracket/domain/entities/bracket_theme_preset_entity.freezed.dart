// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_preset_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketThemePresetEntity {

/// Unique identifier for the preset record.
 String get id;/// ID of the user who owns this preset.
 String get userId;/// The entire theme configuration snapshot.
 TieSheetThemeConfig get themeConfiguration;/// When the preset was created. Also serves as the UI label.
 DateTime get createdAt;
/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetEntityCopyWith<BracketThemePresetEntity> get copyWith => _$BracketThemePresetEntityCopyWithImpl<BracketThemePresetEntity>(this as BracketThemePresetEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themeConfiguration, themeConfiguration) || other.themeConfiguration == themeConfiguration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,themeConfiguration,createdAt);

@override
String toString() {
  return 'BracketThemePresetEntity(id: $id, userId: $userId, themeConfiguration: $themeConfiguration, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetEntityCopyWith<$Res>  {
  factory $BracketThemePresetEntityCopyWith(BracketThemePresetEntity value, $Res Function(BracketThemePresetEntity) _then) = _$BracketThemePresetEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, TieSheetThemeConfig themeConfiguration, DateTime createdAt
});


$TieSheetThemeConfigCopyWith<$Res> get themeConfiguration;

}
/// @nodoc
class _$BracketThemePresetEntityCopyWithImpl<$Res>
    implements $BracketThemePresetEntityCopyWith<$Res> {
  _$BracketThemePresetEntityCopyWithImpl(this._self, this._then);

  final BracketThemePresetEntity _self;
  final $Res Function(BracketThemePresetEntity) _then;

/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? themeConfiguration = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeConfiguration: null == themeConfiguration ? _self.themeConfiguration : themeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get themeConfiguration {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.themeConfiguration, (value) {
    return _then(_self.copyWith(themeConfiguration: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketThemePresetEntity].
extension BracketThemePresetEntityPatterns on BracketThemePresetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketThemePresetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketThemePresetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketThemePresetEntity value)  $default,){
final _that = this;
switch (_that) {
case _BracketThemePresetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketThemePresetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BracketThemePresetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  TieSheetThemeConfig themeConfiguration,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketThemePresetEntity() when $default != null:
return $default(_that.id,_that.userId,_that.themeConfiguration,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  TieSheetThemeConfig themeConfiguration,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BracketThemePresetEntity():
return $default(_that.id,_that.userId,_that.themeConfiguration,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  TieSheetThemeConfig themeConfiguration,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BracketThemePresetEntity() when $default != null:
return $default(_that.id,_that.userId,_that.themeConfiguration,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BracketThemePresetEntity implements BracketThemePresetEntity {
  const _BracketThemePresetEntity({required this.id, required this.userId, required this.themeConfiguration, required this.createdAt});
  

/// Unique identifier for the preset record.
@override final  String id;
/// ID of the user who owns this preset.
@override final  String userId;
/// The entire theme configuration snapshot.
@override final  TieSheetThemeConfig themeConfiguration;
/// When the preset was created. Also serves as the UI label.
@override final  DateTime createdAt;

/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketThemePresetEntityCopyWith<_BracketThemePresetEntity> get copyWith => __$BracketThemePresetEntityCopyWithImpl<_BracketThemePresetEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketThemePresetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themeConfiguration, themeConfiguration) || other.themeConfiguration == themeConfiguration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,themeConfiguration,createdAt);

@override
String toString() {
  return 'BracketThemePresetEntity(id: $id, userId: $userId, themeConfiguration: $themeConfiguration, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BracketThemePresetEntityCopyWith<$Res> implements $BracketThemePresetEntityCopyWith<$Res> {
  factory _$BracketThemePresetEntityCopyWith(_BracketThemePresetEntity value, $Res Function(_BracketThemePresetEntity) _then) = __$BracketThemePresetEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, TieSheetThemeConfig themeConfiguration, DateTime createdAt
});


@override $TieSheetThemeConfigCopyWith<$Res> get themeConfiguration;

}
/// @nodoc
class __$BracketThemePresetEntityCopyWithImpl<$Res>
    implements _$BracketThemePresetEntityCopyWith<$Res> {
  __$BracketThemePresetEntityCopyWithImpl(this._self, this._then);

  final _BracketThemePresetEntity _self;
  final $Res Function(_BracketThemePresetEntity) _then;

/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? themeConfiguration = null,Object? createdAt = null,}) {
  return _then(_BracketThemePresetEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeConfiguration: null == themeConfiguration ? _self.themeConfiguration : themeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BracketThemePresetEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get themeConfiguration {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.themeConfiguration, (value) {
    return _then(_self.copyWith(themeConfiguration: value));
  });
}
}

// dart format on
