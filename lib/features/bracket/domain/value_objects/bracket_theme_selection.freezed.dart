// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
BracketThemeSelection _$BracketThemeSelectionFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'colourfulModeSelected':
          return BracketThemeSelectionColourfulMode.fromJson(
            json
          );
                case 'highContrastModeSelected':
          return BracketThemeSelectionHighContrastMode.fromJson(
            json
          );
                case 'cloudPresetSelected':
          return BracketThemeSelectionCloudPreset.fromJson(
            json
          );
                case 'customModeSelected':
          return BracketThemeSelectionCustomMode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'BracketThemeSelection',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$BracketThemeSelection {



  /// Serializes this BracketThemeSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelection);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelection()';
}


}

/// @nodoc
class $BracketThemeSelectionCopyWith<$Res>  {
$BracketThemeSelectionCopyWith(BracketThemeSelection _, $Res Function(BracketThemeSelection) __);
}


/// Adds pattern-matching-related methods to [BracketThemeSelection].
extension BracketThemeSelectionPatterns on BracketThemeSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketThemeSelectionColourfulMode value)?  colourfulModeSelected,TResult Function( BracketThemeSelectionHighContrastMode value)?  highContrastModeSelected,TResult Function( BracketThemeSelectionCloudPreset value)?  cloudPresetSelected,TResult Function( BracketThemeSelectionCustomMode value)?  customModeSelected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode() when colourfulModeSelected != null:
return colourfulModeSelected(_that);case BracketThemeSelectionHighContrastMode() when highContrastModeSelected != null:
return highContrastModeSelected(_that);case BracketThemeSelectionCloudPreset() when cloudPresetSelected != null:
return cloudPresetSelected(_that);case BracketThemeSelectionCustomMode() when customModeSelected != null:
return customModeSelected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketThemeSelectionColourfulMode value)  colourfulModeSelected,required TResult Function( BracketThemeSelectionHighContrastMode value)  highContrastModeSelected,required TResult Function( BracketThemeSelectionCloudPreset value)  cloudPresetSelected,required TResult Function( BracketThemeSelectionCustomMode value)  customModeSelected,}){
final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode():
return colourfulModeSelected(_that);case BracketThemeSelectionHighContrastMode():
return highContrastModeSelected(_that);case BracketThemeSelectionCloudPreset():
return cloudPresetSelected(_that);case BracketThemeSelectionCustomMode():
return customModeSelected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketThemeSelectionColourfulMode value)?  colourfulModeSelected,TResult? Function( BracketThemeSelectionHighContrastMode value)?  highContrastModeSelected,TResult? Function( BracketThemeSelectionCloudPreset value)?  cloudPresetSelected,TResult? Function( BracketThemeSelectionCustomMode value)?  customModeSelected,}){
final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode() when colourfulModeSelected != null:
return colourfulModeSelected(_that);case BracketThemeSelectionHighContrastMode() when highContrastModeSelected != null:
return highContrastModeSelected(_that);case BracketThemeSelectionCloudPreset() when cloudPresetSelected != null:
return cloudPresetSelected(_that);case BracketThemeSelectionCustomMode() when customModeSelected != null:
return customModeSelected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  colourfulModeSelected,TResult Function()?  highContrastModeSelected,TResult Function( String presetId)?  cloudPresetSelected,TResult Function()?  customModeSelected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode() when colourfulModeSelected != null:
return colourfulModeSelected();case BracketThemeSelectionHighContrastMode() when highContrastModeSelected != null:
return highContrastModeSelected();case BracketThemeSelectionCloudPreset() when cloudPresetSelected != null:
return cloudPresetSelected(_that.presetId);case BracketThemeSelectionCustomMode() when customModeSelected != null:
return customModeSelected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  colourfulModeSelected,required TResult Function()  highContrastModeSelected,required TResult Function( String presetId)  cloudPresetSelected,required TResult Function()  customModeSelected,}) {final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode():
return colourfulModeSelected();case BracketThemeSelectionHighContrastMode():
return highContrastModeSelected();case BracketThemeSelectionCloudPreset():
return cloudPresetSelected(_that.presetId);case BracketThemeSelectionCustomMode():
return customModeSelected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  colourfulModeSelected,TResult? Function()?  highContrastModeSelected,TResult? Function( String presetId)?  cloudPresetSelected,TResult? Function()?  customModeSelected,}) {final _that = this;
switch (_that) {
case BracketThemeSelectionColourfulMode() when colourfulModeSelected != null:
return colourfulModeSelected();case BracketThemeSelectionHighContrastMode() when highContrastModeSelected != null:
return highContrastModeSelected();case BracketThemeSelectionCloudPreset() when cloudPresetSelected != null:
return cloudPresetSelected(_that.presetId);case BracketThemeSelectionCustomMode() when customModeSelected != null:
return customModeSelected();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BracketThemeSelectionColourfulMode extends BracketThemeSelection {
  const BracketThemeSelectionColourfulMode({final  String? $type}): $type = $type ?? 'colourfulModeSelected',super._();
  factory BracketThemeSelectionColourfulMode.fromJson(Map<String, dynamic> json) => _$BracketThemeSelectionColourfulModeFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$BracketThemeSelectionColourfulModeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionColourfulMode);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelection.colourfulModeSelected()';
}


}




/// @nodoc
@JsonSerializable()

class BracketThemeSelectionHighContrastMode extends BracketThemeSelection {
  const BracketThemeSelectionHighContrastMode({final  String? $type}): $type = $type ?? 'highContrastModeSelected',super._();
  factory BracketThemeSelectionHighContrastMode.fromJson(Map<String, dynamic> json) => _$BracketThemeSelectionHighContrastModeFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$BracketThemeSelectionHighContrastModeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionHighContrastMode);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelection.highContrastModeSelected()';
}


}




/// @nodoc
@JsonSerializable()

class BracketThemeSelectionCloudPreset extends BracketThemeSelection {
  const BracketThemeSelectionCloudPreset({required this.presetId, final  String? $type}): $type = $type ?? 'cloudPresetSelected',super._();
  factory BracketThemeSelectionCloudPreset.fromJson(Map<String, dynamic> json) => _$BracketThemeSelectionCloudPresetFromJson(json);

 final  String presetId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BracketThemeSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionCloudPresetCopyWith<BracketThemeSelectionCloudPreset> get copyWith => _$BracketThemeSelectionCloudPresetCopyWithImpl<BracketThemeSelectionCloudPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketThemeSelectionCloudPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionCloudPreset&&(identical(other.presetId, presetId) || other.presetId == presetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,presetId);

@override
String toString() {
  return 'BracketThemeSelection.cloudPresetSelected(presetId: $presetId)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionCloudPresetCopyWith<$Res> implements $BracketThemeSelectionCopyWith<$Res> {
  factory $BracketThemeSelectionCloudPresetCopyWith(BracketThemeSelectionCloudPreset value, $Res Function(BracketThemeSelectionCloudPreset) _then) = _$BracketThemeSelectionCloudPresetCopyWithImpl;
@useResult
$Res call({
 String presetId
});




}
/// @nodoc
class _$BracketThemeSelectionCloudPresetCopyWithImpl<$Res>
    implements $BracketThemeSelectionCloudPresetCopyWith<$Res> {
  _$BracketThemeSelectionCloudPresetCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionCloudPreset _self;
  final $Res Function(BracketThemeSelectionCloudPreset) _then;

/// Create a copy of BracketThemeSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? presetId = null,}) {
  return _then(BracketThemeSelectionCloudPreset(
presetId: null == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BracketThemeSelectionCustomMode extends BracketThemeSelection {
  const BracketThemeSelectionCustomMode({final  String? $type}): $type = $type ?? 'customModeSelected',super._();
  factory BracketThemeSelectionCustomMode.fromJson(Map<String, dynamic> json) => _$BracketThemeSelectionCustomModeFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$BracketThemeSelectionCustomModeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionCustomMode);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelection.customModeSelected()';
}


}




// dart format on
