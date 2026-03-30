// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketThemeSelectionState {

 BracketThemeSelection get activeThemeSelection;/// Populated when the user is in custom editing mode. This holds
/// the live-editing config that updates on every slider/picker change.
/// Separated from the selection union so we can hydrate the "which mode"
/// question independently of the 80+ token config.
 TieSheetThemeConfig? get liveCustomThemeConfiguration;/// Non-null when the last-applied cloud preset could not be resolved
/// (e.g. it was deleted from another device). Triggers a one-time
/// "Theme expired" SnackBar in the UI.
 String? get themeExpiredMessage;
/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemeSelectionStateCopyWith<BracketThemeSelectionState> get copyWith => _$BracketThemeSelectionStateCopyWithImpl<BracketThemeSelectionState>(this as BracketThemeSelectionState, _$identity);

  /// Serializes this BracketThemeSelectionState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemeSelectionState&&(identical(other.activeThemeSelection, activeThemeSelection) || other.activeThemeSelection == activeThemeSelection)&&(identical(other.liveCustomThemeConfiguration, liveCustomThemeConfiguration) || other.liveCustomThemeConfiguration == liveCustomThemeConfiguration)&&(identical(other.themeExpiredMessage, themeExpiredMessage) || other.themeExpiredMessage == themeExpiredMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeThemeSelection,liveCustomThemeConfiguration,themeExpiredMessage);

@override
String toString() {
  return 'BracketThemeSelectionState(activeThemeSelection: $activeThemeSelection, liveCustomThemeConfiguration: $liveCustomThemeConfiguration, themeExpiredMessage: $themeExpiredMessage)';
}


}

/// @nodoc
abstract mixin class $BracketThemeSelectionStateCopyWith<$Res>  {
  factory $BracketThemeSelectionStateCopyWith(BracketThemeSelectionState value, $Res Function(BracketThemeSelectionState) _then) = _$BracketThemeSelectionStateCopyWithImpl;
@useResult
$Res call({
 BracketThemeSelection activeThemeSelection, TieSheetThemeConfig? liveCustomThemeConfiguration, String? themeExpiredMessage
});


$BracketThemeSelectionCopyWith<$Res> get activeThemeSelection;$TieSheetThemeConfigCopyWith<$Res>? get liveCustomThemeConfiguration;

}
/// @nodoc
class _$BracketThemeSelectionStateCopyWithImpl<$Res>
    implements $BracketThemeSelectionStateCopyWith<$Res> {
  _$BracketThemeSelectionStateCopyWithImpl(this._self, this._then);

  final BracketThemeSelectionState _self;
  final $Res Function(BracketThemeSelectionState) _then;

/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeThemeSelection = null,Object? liveCustomThemeConfiguration = freezed,Object? themeExpiredMessage = freezed,}) {
  return _then(_self.copyWith(
activeThemeSelection: null == activeThemeSelection ? _self.activeThemeSelection : activeThemeSelection // ignore: cast_nullable_to_non_nullable
as BracketThemeSelection,liveCustomThemeConfiguration: freezed == liveCustomThemeConfiguration ? _self.liveCustomThemeConfiguration : liveCustomThemeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig?,themeExpiredMessage: freezed == themeExpiredMessage ? _self.themeExpiredMessage : themeExpiredMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketThemeSelectionCopyWith<$Res> get activeThemeSelection {
  
  return $BracketThemeSelectionCopyWith<$Res>(_self.activeThemeSelection, (value) {
    return _then(_self.copyWith(activeThemeSelection: value));
  });
}/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res>? get liveCustomThemeConfiguration {
    if (_self.liveCustomThemeConfiguration == null) {
    return null;
  }

  return $TieSheetThemeConfigCopyWith<$Res>(_self.liveCustomThemeConfiguration!, (value) {
    return _then(_self.copyWith(liveCustomThemeConfiguration: value));
  });
}
}


/// Adds pattern-matching-related methods to [BracketThemeSelectionState].
extension BracketThemeSelectionStatePatterns on BracketThemeSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketThemeSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketThemeSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketThemeSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _BracketThemeSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketThemeSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _BracketThemeSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BracketThemeSelection activeThemeSelection,  TieSheetThemeConfig? liveCustomThemeConfiguration,  String? themeExpiredMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketThemeSelectionState() when $default != null:
return $default(_that.activeThemeSelection,_that.liveCustomThemeConfiguration,_that.themeExpiredMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BracketThemeSelection activeThemeSelection,  TieSheetThemeConfig? liveCustomThemeConfiguration,  String? themeExpiredMessage)  $default,) {final _that = this;
switch (_that) {
case _BracketThemeSelectionState():
return $default(_that.activeThemeSelection,_that.liveCustomThemeConfiguration,_that.themeExpiredMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BracketThemeSelection activeThemeSelection,  TieSheetThemeConfig? liveCustomThemeConfiguration,  String? themeExpiredMessage)?  $default,) {final _that = this;
switch (_that) {
case _BracketThemeSelectionState() when $default != null:
return $default(_that.activeThemeSelection,_that.liveCustomThemeConfiguration,_that.themeExpiredMessage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BracketThemeSelectionState implements BracketThemeSelectionState {
  const _BracketThemeSelectionState({required this.activeThemeSelection, this.liveCustomThemeConfiguration = null, this.themeExpiredMessage = null});
  factory _BracketThemeSelectionState.fromJson(Map<String, dynamic> json) => _$BracketThemeSelectionStateFromJson(json);

@override final  BracketThemeSelection activeThemeSelection;
/// Populated when the user is in custom editing mode. This holds
/// the live-editing config that updates on every slider/picker change.
/// Separated from the selection union so we can hydrate the "which mode"
/// question independently of the 80+ token config.
@override@JsonKey() final  TieSheetThemeConfig? liveCustomThemeConfiguration;
/// Non-null when the last-applied cloud preset could not be resolved
/// (e.g. it was deleted from another device). Triggers a one-time
/// "Theme expired" SnackBar in the UI.
@override@JsonKey() final  String? themeExpiredMessage;

/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketThemeSelectionStateCopyWith<_BracketThemeSelectionState> get copyWith => __$BracketThemeSelectionStateCopyWithImpl<_BracketThemeSelectionState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketThemeSelectionStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketThemeSelectionState&&(identical(other.activeThemeSelection, activeThemeSelection) || other.activeThemeSelection == activeThemeSelection)&&(identical(other.liveCustomThemeConfiguration, liveCustomThemeConfiguration) || other.liveCustomThemeConfiguration == liveCustomThemeConfiguration)&&(identical(other.themeExpiredMessage, themeExpiredMessage) || other.themeExpiredMessage == themeExpiredMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeThemeSelection,liveCustomThemeConfiguration,themeExpiredMessage);

@override
String toString() {
  return 'BracketThemeSelectionState(activeThemeSelection: $activeThemeSelection, liveCustomThemeConfiguration: $liveCustomThemeConfiguration, themeExpiredMessage: $themeExpiredMessage)';
}


}

/// @nodoc
abstract mixin class _$BracketThemeSelectionStateCopyWith<$Res> implements $BracketThemeSelectionStateCopyWith<$Res> {
  factory _$BracketThemeSelectionStateCopyWith(_BracketThemeSelectionState value, $Res Function(_BracketThemeSelectionState) _then) = __$BracketThemeSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 BracketThemeSelection activeThemeSelection, TieSheetThemeConfig? liveCustomThemeConfiguration, String? themeExpiredMessage
});


@override $BracketThemeSelectionCopyWith<$Res> get activeThemeSelection;@override $TieSheetThemeConfigCopyWith<$Res>? get liveCustomThemeConfiguration;

}
/// @nodoc
class __$BracketThemeSelectionStateCopyWithImpl<$Res>
    implements _$BracketThemeSelectionStateCopyWith<$Res> {
  __$BracketThemeSelectionStateCopyWithImpl(this._self, this._then);

  final _BracketThemeSelectionState _self;
  final $Res Function(_BracketThemeSelectionState) _then;

/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeThemeSelection = null,Object? liveCustomThemeConfiguration = freezed,Object? themeExpiredMessage = freezed,}) {
  return _then(_BracketThemeSelectionState(
activeThemeSelection: null == activeThemeSelection ? _self.activeThemeSelection : activeThemeSelection // ignore: cast_nullable_to_non_nullable
as BracketThemeSelection,liveCustomThemeConfiguration: freezed == liveCustomThemeConfiguration ? _self.liveCustomThemeConfiguration : liveCustomThemeConfiguration // ignore: cast_nullable_to_non_nullable
as TieSheetThemeConfig?,themeExpiredMessage: freezed == themeExpiredMessage ? _self.themeExpiredMessage : themeExpiredMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BracketThemeSelectionCopyWith<$Res> get activeThemeSelection {
  
  return $BracketThemeSelectionCopyWith<$Res>(_self.activeThemeSelection, (value) {
    return _then(_self.copyWith(activeThemeSelection: value));
  });
}/// Create a copy of BracketThemeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TieSheetThemeConfigCopyWith<$Res>? get liveCustomThemeConfiguration {
    if (_self.liveCustomThemeConfiguration == null) {
    return null;
  }

  return $TieSheetThemeConfigCopyWith<$Res>(_self.liveCustomThemeConfiguration!, (value) {
    return _then(_self.copyWith(liveCustomThemeConfiguration: value));
  });
}
}

// dart format on
