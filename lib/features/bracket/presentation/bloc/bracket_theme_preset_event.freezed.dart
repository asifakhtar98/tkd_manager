// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_preset_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketThemePresetEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemePresetEvent()';
}


}

/// @nodoc
class $BracketThemePresetEventCopyWith<$Res>  {
$BracketThemePresetEventCopyWith(BracketThemePresetEvent _, $Res Function(BracketThemePresetEvent) __);
}


/// Adds pattern-matching-related methods to [BracketThemePresetEvent].
extension BracketThemePresetEventPatterns on BracketThemePresetEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketThemePresetLoadRequested value)?  loadRequested,TResult Function( BracketThemePresetSaveRequested value)?  saveRequested,TResult Function( BracketThemePresetDeleteRequested value)?  deleteRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested() when loadRequested != null:
return loadRequested(_that);case BracketThemePresetSaveRequested() when saveRequested != null:
return saveRequested(_that);case BracketThemePresetDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketThemePresetLoadRequested value)  loadRequested,required TResult Function( BracketThemePresetSaveRequested value)  saveRequested,required TResult Function( BracketThemePresetDeleteRequested value)  deleteRequested,}){
final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested():
return loadRequested(_that);case BracketThemePresetSaveRequested():
return saveRequested(_that);case BracketThemePresetDeleteRequested():
return deleteRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketThemePresetLoadRequested value)?  loadRequested,TResult? Function( BracketThemePresetSaveRequested value)?  saveRequested,TResult? Function( BracketThemePresetDeleteRequested value)?  deleteRequested,}){
final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested() when loadRequested != null:
return loadRequested(_that);case BracketThemePresetSaveRequested() when saveRequested != null:
return saveRequested(_that);case BracketThemePresetDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( TieSheetThemeConfig themeConfiguration)?  saveRequested,TResult Function( String presetId)?  deleteRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested() when loadRequested != null:
return loadRequested();case BracketThemePresetSaveRequested() when saveRequested != null:
return saveRequested(_that.themeConfiguration);case BracketThemePresetDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.presetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( TieSheetThemeConfig themeConfiguration)  saveRequested,required TResult Function( String presetId)  deleteRequested,}) {final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested():
return loadRequested();case BracketThemePresetSaveRequested():
return saveRequested(_that.themeConfiguration);case BracketThemePresetDeleteRequested():
return deleteRequested(_that.presetId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( TieSheetThemeConfig themeConfiguration)?  saveRequested,TResult? Function( String presetId)?  deleteRequested,}) {final _that = this;
switch (_that) {
case BracketThemePresetLoadRequested() when loadRequested != null:
return loadRequested();case BracketThemePresetSaveRequested() when saveRequested != null:
return saveRequested(_that.themeConfiguration);case BracketThemePresetDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.presetId);case _:
  return null;

}
}

}

/// @nodoc


class BracketThemePresetLoadRequested implements BracketThemePresetEvent {
  const BracketThemePresetLoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetLoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemePresetEvent.loadRequested()';
}


}




/// @nodoc


class BracketThemePresetSaveRequested implements BracketThemePresetEvent {
  const BracketThemePresetSaveRequested({required this.themeConfiguration});
  

 final  TieSheetThemeConfig themeConfiguration;

/// Create a copy of BracketThemePresetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetSaveRequestedCopyWith<BracketThemePresetSaveRequested> get copyWith => _$BracketThemePresetSaveRequestedCopyWithImpl<BracketThemePresetSaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetSaveRequested&&(identical(other.themeConfiguration, themeConfiguration) || other.themeConfiguration == themeConfiguration));
}


@override
int get hashCode => Object.hash(runtimeType,themeConfiguration);

@override
String toString() {
  return 'BracketThemePresetEvent.saveRequested(themeConfiguration: $themeConfiguration)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetSaveRequestedCopyWith<$Res> implements $BracketThemePresetEventCopyWith<$Res> {
  factory $BracketThemePresetSaveRequestedCopyWith(BracketThemePresetSaveRequested value, $Res Function(BracketThemePresetSaveRequested) _then) = _$BracketThemePresetSaveRequestedCopyWithImpl;
@useResult
$Res call({
 TieSheetThemeConfig themeConfiguration
});


$TieSheetThemeConfigCopyWith<$Res> get themeConfiguration;

}
/// @nodoc
class _$BracketThemePresetSaveRequestedCopyWithImpl<$Res>
    implements $BracketThemePresetSaveRequestedCopyWith<$Res> {
  _$BracketThemePresetSaveRequestedCopyWithImpl(this._self, this._then);

  final BracketThemePresetSaveRequested _self;
  final $Res Function(BracketThemePresetSaveRequested) _then;

/// Create a copy of BracketThemePresetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeConfiguration = null,}) {
  return _then(BracketThemePresetSaveRequested(
themeConfiguration: null == themeConfiguration ? _self.themeConfiguration : themeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig,
  ));
}

/// Create a copy of BracketThemePresetEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res> get themeConfiguration {
  
  return $TieSheetThemeConfigCopyWith<$Res>(_self.themeConfiguration, (value) {
    return _then(_self.copyWith(themeConfiguration: value));
  });
}
}

/// @nodoc


class BracketThemePresetDeleteRequested implements BracketThemePresetEvent {
  const BracketThemePresetDeleteRequested({required this.presetId});
  

 final  String presetId;

/// Create a copy of BracketThemePresetEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetDeleteRequestedCopyWith<BracketThemePresetDeleteRequested> get copyWith => _$BracketThemePresetDeleteRequestedCopyWithImpl<BracketThemePresetDeleteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetDeleteRequested&&(identical(other.presetId, presetId) || other.presetId == presetId));
}


@override
int get hashCode => Object.hash(runtimeType,presetId);

@override
String toString() {
  return 'BracketThemePresetEvent.deleteRequested(presetId: $presetId)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetDeleteRequestedCopyWith<$Res> implements $BracketThemePresetEventCopyWith<$Res> {
  factory $BracketThemePresetDeleteRequestedCopyWith(BracketThemePresetDeleteRequested value, $Res Function(BracketThemePresetDeleteRequested) _then) = _$BracketThemePresetDeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String presetId
});




}
/// @nodoc
class _$BracketThemePresetDeleteRequestedCopyWithImpl<$Res>
    implements $BracketThemePresetDeleteRequestedCopyWith<$Res> {
  _$BracketThemePresetDeleteRequestedCopyWithImpl(this._self, this._then);

  final BracketThemePresetDeleteRequested _self;
  final $Res Function(BracketThemePresetDeleteRequested) _then;

/// Create a copy of BracketThemePresetEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? presetId = null,}) {
  return _then(BracketThemePresetDeleteRequested(
presetId: null == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
