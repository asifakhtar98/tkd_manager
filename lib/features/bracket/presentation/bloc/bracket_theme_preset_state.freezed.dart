// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_theme_preset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketThemePresetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemePresetState()';
}


}

/// @nodoc
class $BracketThemePresetStateCopyWith<$Res>  {
$BracketThemePresetStateCopyWith(BracketThemePresetState _, $Res Function(BracketThemePresetState) __);
}


/// Adds pattern-matching-related methods to [BracketThemePresetState].
extension BracketThemePresetStatePatterns on BracketThemePresetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketThemePresetInitial value)?  initial,TResult Function( BracketThemePresetLoading value)?  loading,TResult Function( BracketThemePresetLoaded value)?  loaded,TResult Function( BracketThemePresetError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketThemePresetInitial() when initial != null:
return initial(_that);case BracketThemePresetLoading() when loading != null:
return loading(_that);case BracketThemePresetLoaded() when loaded != null:
return loaded(_that);case BracketThemePresetError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketThemePresetInitial value)  initial,required TResult Function( BracketThemePresetLoading value)  loading,required TResult Function( BracketThemePresetLoaded value)  loaded,required TResult Function( BracketThemePresetError value)  error,}){
final _that = this;
switch (_that) {
case BracketThemePresetInitial():
return initial(_that);case BracketThemePresetLoading():
return loading(_that);case BracketThemePresetLoaded():
return loaded(_that);case BracketThemePresetError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketThemePresetInitial value)?  initial,TResult? Function( BracketThemePresetLoading value)?  loading,TResult? Function( BracketThemePresetLoaded value)?  loaded,TResult? Function( BracketThemePresetError value)?  error,}){
final _that = this;
switch (_that) {
case BracketThemePresetInitial() when initial != null:
return initial(_that);case BracketThemePresetLoading() when loading != null:
return loading(_that);case BracketThemePresetLoaded() when loaded != null:
return loaded(_that);case BracketThemePresetError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BracketThemePresetEntity> presets)?  loaded,TResult Function( String message,  List<BracketThemePresetEntity> previousPresets)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketThemePresetInitial() when initial != null:
return initial();case BracketThemePresetLoading() when loading != null:
return loading();case BracketThemePresetLoaded() when loaded != null:
return loaded(_that.presets);case BracketThemePresetError() when error != null:
return error(_that.message,_that.previousPresets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BracketThemePresetEntity> presets)  loaded,required TResult Function( String message,  List<BracketThemePresetEntity> previousPresets)  error,}) {final _that = this;
switch (_that) {
case BracketThemePresetInitial():
return initial();case BracketThemePresetLoading():
return loading();case BracketThemePresetLoaded():
return loaded(_that.presets);case BracketThemePresetError():
return error(_that.message,_that.previousPresets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BracketThemePresetEntity> presets)?  loaded,TResult? Function( String message,  List<BracketThemePresetEntity> previousPresets)?  error,}) {final _that = this;
switch (_that) {
case BracketThemePresetInitial() when initial != null:
return initial();case BracketThemePresetLoading() when loading != null:
return loading();case BracketThemePresetLoaded() when loaded != null:
return loaded(_that.presets);case BracketThemePresetError() when error != null:
return error(_that.message,_that.previousPresets);case _:
  return null;

}
}

}

/// @nodoc


class BracketThemePresetInitial implements BracketThemePresetState {
  const BracketThemePresetInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemePresetState.initial()';
}


}




/// @nodoc


class BracketThemePresetLoading implements BracketThemePresetState {
  const BracketThemePresetLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BracketThemePresetState.loading()';
}


}




/// @nodoc


class BracketThemePresetLoaded implements BracketThemePresetState {
  const BracketThemePresetLoaded({required final  List<BracketThemePresetEntity> presets}): _presets = presets;
  

 final  List<BracketThemePresetEntity> _presets;
 List<BracketThemePresetEntity> get presets {
  if (_presets is EqualUnmodifiableListView) return _presets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presets);
}


/// Create a copy of BracketThemePresetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetLoadedCopyWith<BracketThemePresetLoaded> get copyWith => _$BracketThemePresetLoadedCopyWithImpl<BracketThemePresetLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetLoaded&&const DeepCollectionEquality().equals(other._presets, _presets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_presets));

@override
String toString() {
  return 'BracketThemePresetState.loaded(presets: $presets)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetLoadedCopyWith<$Res> implements $BracketThemePresetStateCopyWith<$Res> {
  factory $BracketThemePresetLoadedCopyWith(BracketThemePresetLoaded value, $Res Function(BracketThemePresetLoaded) _then) = _$BracketThemePresetLoadedCopyWithImpl;
@useResult
$Res call({
 List<BracketThemePresetEntity> presets
});




}
/// @nodoc
class _$BracketThemePresetLoadedCopyWithImpl<$Res>
    implements $BracketThemePresetLoadedCopyWith<$Res> {
  _$BracketThemePresetLoadedCopyWithImpl(this._self, this._then);

  final BracketThemePresetLoaded _self;
  final $Res Function(BracketThemePresetLoaded) _then;

/// Create a copy of BracketThemePresetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? presets = null,}) {
  return _then(BracketThemePresetLoaded(
presets: null == presets ? _self._presets : presets // ignore: cast_nullable_to_non_nullable
as List<BracketThemePresetEntity>,
  ));
}


}

/// @nodoc


class BracketThemePresetError implements BracketThemePresetState {
  const BracketThemePresetError({required this.message, final  List<BracketThemePresetEntity> previousPresets = const []}): _previousPresets = previousPresets;
  

 final  String message;
 final  List<BracketThemePresetEntity> _previousPresets;
@JsonKey() List<BracketThemePresetEntity> get previousPresets {
  if (_previousPresets is EqualUnmodifiableListView) return _previousPresets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_previousPresets);
}


/// Create a copy of BracketThemePresetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketThemePresetErrorCopyWith<BracketThemePresetError> get copyWith => _$BracketThemePresetErrorCopyWithImpl<BracketThemePresetError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketThemePresetError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._previousPresets, _previousPresets));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_previousPresets));

@override
String toString() {
  return 'BracketThemePresetState.error(message: $message, previousPresets: $previousPresets)';
}


}

/// @nodoc
abstract mixin class $BracketThemePresetErrorCopyWith<$Res> implements $BracketThemePresetStateCopyWith<$Res> {
  factory $BracketThemePresetErrorCopyWith(BracketThemePresetError value, $Res Function(BracketThemePresetError) _then) = _$BracketThemePresetErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<BracketThemePresetEntity> previousPresets
});




}
/// @nodoc
class _$BracketThemePresetErrorCopyWithImpl<$Res>
    implements $BracketThemePresetErrorCopyWith<$Res> {
  _$BracketThemePresetErrorCopyWithImpl(this._self, this._then);

  final BracketThemePresetError _self;
  final $Res Function(BracketThemePresetError) _then;

/// Create a copy of BracketThemePresetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousPresets = null,}) {
  return _then(BracketThemePresetError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousPresets: null == previousPresets ? _self._previousPresets : previousPresets // ignore: cast_nullable_to_non_nullable
as List<BracketThemePresetEntity>,
  ));
}


}

// dart format on
