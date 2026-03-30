// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_selection_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketThemeSelectionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelectionEvent()';
}


}

/// @nodoc
class $BracketThemeSelectionEventCopyWith<$Res>  {
$BracketThemeSelectionEventCopyWith(BracketThemeSelectionEvent _, $Res Function(BracketThemeSelectionEvent) __);
}


/// Adds pattern-matching-related methods to [BracketThemeSelectionEvent].
extension BracketThemeSelectionEventPatterns on BracketThemeSelectionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketThemeSelectionModeToggled value)?  themeModeToggled,TResult Function( BracketThemeSelectionCloudPresetApplied value)?  cloudPresetApplied,TResult Function( BracketThemeSelectionCustomConfigUpdated value)?  customThemeConfigurationUpdated,TResult Function( BracketThemeSelectionHydratedResolved value)?  hydratedSelectionResolved,TResult Function( BracketThemeSelectionExpiredDismissed value)?  themeExpiredMessageDismissed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled() when themeModeToggled != null:
return themeModeToggled(_that);case BracketThemeSelectionCloudPresetApplied() when cloudPresetApplied != null:
return cloudPresetApplied(_that);case BracketThemeSelectionCustomConfigUpdated() when customThemeConfigurationUpdated != null:
return customThemeConfigurationUpdated(_that);case BracketThemeSelectionHydratedResolved() when hydratedSelectionResolved != null:
return hydratedSelectionResolved(_that);case BracketThemeSelectionExpiredDismissed() when themeExpiredMessageDismissed != null:
return themeExpiredMessageDismissed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketThemeSelectionModeToggled value)  themeModeToggled,required TResult Function( BracketThemeSelectionCloudPresetApplied value)  cloudPresetApplied,required TResult Function( BracketThemeSelectionCustomConfigUpdated value)  customThemeConfigurationUpdated,required TResult Function( BracketThemeSelectionHydratedResolved value)  hydratedSelectionResolved,required TResult Function( BracketThemeSelectionExpiredDismissed value)  themeExpiredMessageDismissed,}){
final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled():
return themeModeToggled(_that);case BracketThemeSelectionCloudPresetApplied():
return cloudPresetApplied(_that);case BracketThemeSelectionCustomConfigUpdated():
return customThemeConfigurationUpdated(_that);case BracketThemeSelectionHydratedResolved():
return hydratedSelectionResolved(_that);case BracketThemeSelectionExpiredDismissed():
return themeExpiredMessageDismissed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketThemeSelectionModeToggled value)?  themeModeToggled,TResult? Function( BracketThemeSelectionCloudPresetApplied value)?  cloudPresetApplied,TResult? Function( BracketThemeSelectionCustomConfigUpdated value)?  customThemeConfigurationUpdated,TResult? Function( BracketThemeSelectionHydratedResolved value)?  hydratedSelectionResolved,TResult? Function( BracketThemeSelectionExpiredDismissed value)?  themeExpiredMessageDismissed,}){
final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled() when themeModeToggled != null:
return themeModeToggled(_that);case BracketThemeSelectionCloudPresetApplied() when cloudPresetApplied != null:
return cloudPresetApplied(_that);case BracketThemeSelectionCustomConfigUpdated() when customThemeConfigurationUpdated != null:
return customThemeConfigurationUpdated(_that);case BracketThemeSelectionHydratedResolved() when hydratedSelectionResolved != null:
return hydratedSelectionResolved(_that);case BracketThemeSelectionExpiredDismissed() when themeExpiredMessageDismissed != null:
return themeExpiredMessageDismissed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TieSheetThemeMode selectedMode)?  themeModeToggled,TResult Function( String presetId,  TieSheetThemeConfig resolvedThemeConfiguration)?  cloudPresetApplied,TResult Function( TieSheetThemeConfig updatedThemeConfiguration)?  customThemeConfigurationUpdated,TResult Function( List<BracketThemePresetEntity> availableCloudPresets)?  hydratedSelectionResolved,TResult Function()?  themeExpiredMessageDismissed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled() when themeModeToggled != null:
return themeModeToggled(_that.selectedMode);case BracketThemeSelectionCloudPresetApplied() when cloudPresetApplied != null:
return cloudPresetApplied(_that.presetId,_that.resolvedThemeConfiguration);case BracketThemeSelectionCustomConfigUpdated() when customThemeConfigurationUpdated != null:
return customThemeConfigurationUpdated(_that.updatedThemeConfiguration);case BracketThemeSelectionHydratedResolved() when hydratedSelectionResolved != null:
return hydratedSelectionResolved(_that.availableCloudPresets);case BracketThemeSelectionExpiredDismissed() when themeExpiredMessageDismissed != null:
return themeExpiredMessageDismissed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TieSheetThemeMode selectedMode)  themeModeToggled,required TResult Function( String presetId,  TieSheetThemeConfig resolvedThemeConfiguration)  cloudPresetApplied,required TResult Function( TieSheetThemeConfig updatedThemeConfiguration)  customThemeConfigurationUpdated,required TResult Function( List<BracketThemePresetEntity> availableCloudPresets)  hydratedSelectionResolved,required TResult Function()  themeExpiredMessageDismissed,}) {final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled():
return themeModeToggled(_that.selectedMode);case BracketThemeSelectionCloudPresetApplied():
return cloudPresetApplied(_that.presetId,_that.resolvedThemeConfiguration);case BracketThemeSelectionCustomConfigUpdated():
return customThemeConfigurationUpdated(_that.updatedThemeConfiguration);case BracketThemeSelectionHydratedResolved():
return hydratedSelectionResolved(_that.availableCloudPresets);case BracketThemeSelectionExpiredDismissed():
return themeExpiredMessageDismissed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TieSheetThemeMode selectedMode)?  themeModeToggled,TResult? Function( String presetId,  TieSheetThemeConfig resolvedThemeConfiguration)?  cloudPresetApplied,TResult? Function( TieSheetThemeConfig updatedThemeConfiguration)?  customThemeConfigurationUpdated,TResult? Function( List<BracketThemePresetEntity> availableCloudPresets)?  hydratedSelectionResolved,TResult? Function()?  themeExpiredMessageDismissed,}) {final _that = this;
switch (_that) {
case BracketThemeSelectionModeToggled() when themeModeToggled != null:
return themeModeToggled(_that.selectedMode);case BracketThemeSelectionCloudPresetApplied() when cloudPresetApplied != null:
return cloudPresetApplied(_that.presetId,_that.resolvedThemeConfiguration);case BracketThemeSelectionCustomConfigUpdated() when customThemeConfigurationUpdated != null:
return customThemeConfigurationUpdated(_that.updatedThemeConfiguration);case BracketThemeSelectionHydratedResolved() when hydratedSelectionResolved != null:
return hydratedSelectionResolved(_that.availableCloudPresets);case BracketThemeSelectionExpiredDismissed() when themeExpiredMessageDismissed != null:
return themeExpiredMessageDismissed();case _:
  return null;

}
}

}

/// @nodoc


class BracketThemeSelectionModeToggled implements BracketThemeSelectionEvent {
  const BracketThemeSelectionModeToggled({required this.selectedMode});
  

 final  TieSheetThemeMode selectedMode;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionModeToggledCopyWith<BracketThemeSelectionModeToggled> get copyWith => _$BracketThemeSelectionModeToggledCopyWithImpl<BracketThemeSelectionModeToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionModeToggled&&(identical(other.selectedMode, selectedMode) || other.selectedMode == selectedMode));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMode);

@override
String toString() {
  return 'BracketThemeSelectionEvent.themeModeToggled(selectedMode: $selectedMode)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionModeToggledCopyWith<$Res> implements $BracketThemeSelectionEventCopyWith<$Res> {
  factory $BracketThemeSelectionModeToggledCopyWith(BracketThemeSelectionModeToggled value, $Res Function(BracketThemeSelectionModeToggled) _then) = _$BracketThemeSelectionModeToggledCopyWithImpl;
@useResult
$Res call({
 TieSheetThemeMode selectedMode
});




}
/// @nodoc
class _$BracketThemeSelectionModeToggledCopyWithImpl<$Res>
    implements $BracketThemeSelectionModeToggledCopyWith<$Res> {
  _$BracketThemeSelectionModeToggledCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionModeToggled _self;
  final $Res Function(BracketThemeSelectionModeToggled) _then;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedMode = null,}) {
  return _then(BracketThemeSelectionModeToggled(
selectedMode: null == selectedMode ? _self.selectedMode : selectedMode // ignore: cast_nullable_to_non_nullable
as TieSheetThemeMode,
  ));
}


}

/// @nodoc


class BracketThemeSelectionCloudPresetApplied implements BracketThemeSelectionEvent {
  const BracketThemeSelectionCloudPresetApplied({required this.presetId, required this.resolvedThemeConfiguration});
  

 final  String presetId;
 final  TieSheetThemeConfig resolvedThemeConfiguration;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionCloudPresetAppliedCopyWith<BracketThemeSelectionCloudPresetApplied> get copyWith => _$BracketThemeSelectionCloudPresetAppliedCopyWithImpl<BracketThemeSelectionCloudPresetApplied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionCloudPresetApplied&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.resolvedThemeConfiguration, resolvedThemeConfiguration) || other.resolvedThemeConfiguration == resolvedThemeConfiguration));
}


@override
int get hashCode => Object.hash(runtimeType,presetId,resolvedThemeConfiguration);

@override
String toString() {
  return 'BracketThemeSelectionEvent.cloudPresetApplied(presetId: $presetId, resolvedThemeConfiguration: $resolvedThemeConfiguration)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionCloudPresetAppliedCopyWith<$Res> implements $BracketThemeSelectionEventCopyWith<$Res> {
  factory $BracketThemeSelectionCloudPresetAppliedCopyWith(BracketThemeSelectionCloudPresetApplied value, $Res Function(BracketThemeSelectionCloudPresetApplied) _then) = _$BracketThemeSelectionCloudPresetAppliedCopyWithImpl;
@useResult
$Res call({
 String presetId, TieSheetThemeConfig resolvedThemeConfiguration
});


$TieSheetThemeConfigCopyWith<$Res> get resolvedThemeConfiguration;

}
/// @nodoc
class _$BracketThemeSelectionCloudPresetAppliedCopyWithImpl<$Res>
    implements $BracketThemeSelectionCloudPresetAppliedCopyWith<$Res> {
  _$BracketThemeSelectionCloudPresetAppliedCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionCloudPresetApplied _self;
  final $Res Function(BracketThemeSelectionCloudPresetApplied) _then;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? presetId = null,Object? resolvedThemeConfiguration = null,}) {
  return _then(BracketThemeSelectionCloudPresetApplied(
presetId: null == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String,resolvedThemeConfiguration: null == resolvedThemeConfiguration ? _self.resolvedThemeConfiguration : resolvedThemeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,
  ));
}

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get resolvedThemeConfiguration {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.resolvedThemeConfiguration, (value) {
    return _then(_self.copyWith(resolvedThemeConfiguration: value));
  });
}
}

/// @nodoc


class BracketThemeSelectionCustomConfigUpdated implements BracketThemeSelectionEvent {
  const BracketThemeSelectionCustomConfigUpdated({required this.updatedThemeConfiguration});
  

 final  TieSheetThemeConfig updatedThemeConfiguration;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionCustomConfigUpdatedCopyWith<BracketThemeSelectionCustomConfigUpdated> get copyWith => _$BracketThemeSelectionCustomConfigUpdatedCopyWithImpl<BracketThemeSelectionCustomConfigUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionCustomConfigUpdated&&(identical(other.updatedThemeConfiguration, updatedThemeConfiguration) || other.updatedThemeConfiguration == updatedThemeConfiguration));
}


@override
int get hashCode => Object.hash(runtimeType,updatedThemeConfiguration);

@override
String toString() {
  return 'BracketThemeSelectionEvent.customThemeConfigurationUpdated(updatedThemeConfiguration: $updatedThemeConfiguration)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionCustomConfigUpdatedCopyWith<$Res> implements $BracketThemeSelectionEventCopyWith<$Res> {
  factory $BracketThemeSelectionCustomConfigUpdatedCopyWith(BracketThemeSelectionCustomConfigUpdated value, $Res Function(BracketThemeSelectionCustomConfigUpdated) _then) = _$BracketThemeSelectionCustomConfigUpdatedCopyWithImpl;
@useResult
$Res call({
 TieSheetThemeConfig updatedThemeConfiguration
});


$TieSheetThemeConfigCopyWith<$Res> get updatedThemeConfiguration;

}
/// @nodoc
class _$BracketThemeSelectionCustomConfigUpdatedCopyWithImpl<$Res>
    implements $BracketThemeSelectionCustomConfigUpdatedCopyWith<$Res> {
  _$BracketThemeSelectionCustomConfigUpdatedCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionCustomConfigUpdated _self;
  final $Res Function(BracketThemeSelectionCustomConfigUpdated) _then;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? updatedThemeConfiguration = null,}) {
  return _then(BracketThemeSelectionCustomConfigUpdated(
updatedThemeConfiguration: null == updatedThemeConfiguration ? _self.updatedThemeConfiguration : updatedThemeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,
  ));
}

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get updatedThemeConfiguration {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.updatedThemeConfiguration, (value) {
    return _then(_self.copyWith(updatedThemeConfiguration: value));
  });
}
}

/// @nodoc


class BracketThemeSelectionHydratedResolved implements BracketThemeSelectionEvent {
  const BracketThemeSelectionHydratedResolved({required final  List<BracketThemePresetEntity> availableCloudPresets}): _availableCloudPresets = availableCloudPresets;
  

 final  List<BracketThemePresetEntity> _availableCloudPresets;
 List<BracketThemePresetEntity> get availableCloudPresets {
  if (_availableCloudPresets is EqualUnmodifiableListView) return _availableCloudPresets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCloudPresets);
}


/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionHydratedResolvedCopyWith<BracketThemeSelectionHydratedResolved> get copyWith => _$BracketThemeSelectionHydratedResolvedCopyWithImpl<BracketThemeSelectionHydratedResolved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionHydratedResolved&&const DeepCollectionEquality().equals(other._availableCloudPresets, _availableCloudPresets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_availableCloudPresets));

@override
String toString() {
  return 'BracketThemeSelectionEvent.hydratedSelectionResolved(availableCloudPresets: $availableCloudPresets)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionHydratedResolvedCopyWith<$Res> implements $BracketThemeSelectionEventCopyWith<$Res> {
  factory $BracketThemeSelectionHydratedResolvedCopyWith(BracketThemeSelectionHydratedResolved value, $Res Function(BracketThemeSelectionHydratedResolved) _then) = _$BracketThemeSelectionHydratedResolvedCopyWithImpl;
@useResult
$Res call({
 List<BracketThemePresetEntity> availableCloudPresets
});




}
/// @nodoc
class _$BracketThemeSelectionHydratedResolvedCopyWithImpl<$Res>
    implements $BracketThemeSelectionHydratedResolvedCopyWith<$Res> {
  _$BracketThemeSelectionHydratedResolvedCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionHydratedResolved _self;
  final $Res Function(BracketThemeSelectionHydratedResolved) _then;

/// Create a copy of BracketThemeSelectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? availableCloudPresets = null,}) {
  return _then(BracketThemeSelectionHydratedResolved(
availableCloudPresets: null == availableCloudPresets ? _self._availableCloudPresets : availableCloudPresets // ignore: cast_nullable_to_non_nullable
as List<BracketThemePresetEntity>,
  ));
}


}

/// @nodoc


class BracketThemeSelectionExpiredDismissed implements BracketThemeSelectionEvent {
  const BracketThemeSelectionExpiredDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionExpiredDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemeSelectionEvent.themeExpiredMessageDismissed()';
}


}




// dart format on
