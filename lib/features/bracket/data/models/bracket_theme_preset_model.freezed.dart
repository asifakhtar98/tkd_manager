// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_preset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketThemePresetModel {

 String get id; String get userId; TieSheetThemeConfig get themeConfig; DateTime get createdAt;
/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetModelCopyWith<BracketThemePresetModel> get copyWith => _$BracketThemePresetModelCopyWithImpl<BracketThemePresetModel>(this as BracketThemePresetModel, _$identity);

  /// Serializes this BracketThemePresetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themeConfig, themeConfig) || other.themeConfig == themeConfig)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,themeConfig,createdAt);

@override
String toString() {
  return 'BracketThemePresetModel(id: $id, userId: $userId, themeConfig: $themeConfig, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetModelCopyWith<$Res>  {
  factory $BracketThemePresetModelCopyWith(BracketThemePresetModel value, $Res Function(BracketThemePresetModel) _then) = _$BracketThemePresetModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, TieSheetThemeConfig themeConfig, DateTime createdAt
});


$TieSheetThemeConfigCopyWith<$Res> get themeConfig;

}
/// @nodoc
class _$BracketThemePresetModelCopyWithImpl<$Res>
    implements $BracketThemePresetModelCopyWith<$Res> {
  _$BracketThemePresetModelCopyWithImpl(this._self, this._then);

  final BracketThemePresetModel _self;
  final $Res Function(BracketThemePresetModel) _then;

/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? themeConfig = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeConfig: null == themeConfig ? _self.themeConfig : themeConfig // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get themeConfig {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.themeConfig, (value) {
    return _then(_self.copyWith(themeConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketThemePresetModel].
extension BracketThemePresetModelPatterns on BracketThemePresetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketThemePresetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketThemePresetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketThemePresetModel value)  $default,){
final _that = this;
switch (_that) {
case _BracketThemePresetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketThemePresetModel value)?  $default,){
final _that = this;
switch (_that) {
case _BracketThemePresetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  TieSheetThemeConfig themeConfig,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketThemePresetModel() when $default != null:
return $default(_that.id,_that.userId,_that.themeConfig,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  TieSheetThemeConfig themeConfig,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BracketThemePresetModel():
return $default(_that.id,_that.userId,_that.themeConfig,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  TieSheetThemeConfig themeConfig,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BracketThemePresetModel() when $default != null:
return $default(_that.id,_that.userId,_that.themeConfig,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _BracketThemePresetModel extends BracketThemePresetModel {
  const _BracketThemePresetModel({required this.id, required this.userId, required this.themeConfig, required this.createdAt}): super._();
  factory _BracketThemePresetModel.fromJson(Map<String, dynamic> json) => _$BracketThemePresetModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  TieSheetThemeConfig themeConfig;
@override final  DateTime createdAt;

/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketThemePresetModelCopyWith<_BracketThemePresetModel> get copyWith => __$BracketThemePresetModelCopyWithImpl<_BracketThemePresetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketThemePresetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketThemePresetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themeConfig, themeConfig) || other.themeConfig == themeConfig)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,themeConfig,createdAt);

@override
String toString() {
  return 'BracketThemePresetModel(id: $id, userId: $userId, themeConfig: $themeConfig, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BracketThemePresetModelCopyWith<$Res> implements $BracketThemePresetModelCopyWith<$Res> {
  factory _$BracketThemePresetModelCopyWith(_BracketThemePresetModel value, $Res Function(_BracketThemePresetModel) _then) = __$BracketThemePresetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, TieSheetThemeConfig themeConfig, DateTime createdAt
});


@override $TieSheetThemeConfigCopyWith<$Res> get themeConfig;

}
/// @nodoc
class __$BracketThemePresetModelCopyWithImpl<$Res>
    implements _$BracketThemePresetModelCopyWith<$Res> {
  __$BracketThemePresetModelCopyWithImpl(this._self, this._then);

  final _BracketThemePresetModel _self;
  final $Res Function(_BracketThemePresetModel) _then;

/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? themeConfig = null,Object? createdAt = null,}) {
  return _then(_BracketThemePresetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themeConfig: null == themeConfig ? _self.themeConfig : themeConfig // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BracketThemePresetModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get themeConfig {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.themeConfig, (value) {
    return _then(_self.copyWith(themeConfig: value));
  });
}
}

// dart format on
