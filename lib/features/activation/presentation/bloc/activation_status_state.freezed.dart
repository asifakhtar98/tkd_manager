// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_status_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationStatusState {

 bool get isLoading; ActivationStatus? get activationStatus; bool get isAdmin; Failure? get error;
/// Create a copy of ActivationStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationStatusStateCopyWith<ActivationStatusState> get copyWith => _$ActivationStatusStateCopyWithImpl<ActivationStatusState>(this as ActivationStatusState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationStatusState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.activationStatus, activationStatus) || other.activationStatus == activationStatus)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,activationStatus,isAdmin,error);

@override
String toString() {
  return 'ActivationStatusState(isLoading: $isLoading, activationStatus: $activationStatus, isAdmin: $isAdmin, error: $error)';
}


}

/// @nodoc
abstract mixin class $ActivationStatusStateCopyWith<$Res>  {
  factory $ActivationStatusStateCopyWith(ActivationStatusState value, $Res Function(ActivationStatusState) _then) = _$ActivationStatusStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ActivationStatus? activationStatus, bool isAdmin, Failure? error
});




}
/// @nodoc
class _$ActivationStatusStateCopyWithImpl<$Res>
    implements $ActivationStatusStateCopyWith<$Res> {
  _$ActivationStatusStateCopyWithImpl(this._self, this._then);

  final ActivationStatusState _self;
  final $Res Function(ActivationStatusState) _then;

/// Create a copy of ActivationStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? activationStatus = freezed,Object? isAdmin = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activationStatus: freezed == activationStatus ? _self.activationStatus : activationStatus // ignore: cast_nullable_to_non_nullable
as ActivationStatus?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationStatusState].
extension ActivationStatusStatePatterns on ActivationStatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationStatusState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationStatusState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationStatusState value)  $default,){
final _that = this;
switch (_that) {
case _ActivationStatusState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationStatusState value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationStatusState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ActivationStatus? activationStatus,  bool isAdmin,  Failure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationStatusState() when $default != null:
return $default(_that.isLoading,_that.activationStatus,_that.isAdmin,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ActivationStatus? activationStatus,  bool isAdmin,  Failure? error)  $default,) {final _that = this;
switch (_that) {
case _ActivationStatusState():
return $default(_that.isLoading,_that.activationStatus,_that.isAdmin,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ActivationStatus? activationStatus,  bool isAdmin,  Failure? error)?  $default,) {final _that = this;
switch (_that) {
case _ActivationStatusState() when $default != null:
return $default(_that.isLoading,_that.activationStatus,_that.isAdmin,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationStatusState implements ActivationStatusState {
  const _ActivationStatusState({this.isLoading = true, this.activationStatus, this.isAdmin = false, this.error});
  

@override@JsonKey() final  bool isLoading;
@override final  ActivationStatus? activationStatus;
@override@JsonKey() final  bool isAdmin;
@override final  Failure? error;

/// Create a copy of ActivationStatusState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationStatusStateCopyWith<_ActivationStatusState> get copyWith => __$ActivationStatusStateCopyWithImpl<_ActivationStatusState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationStatusState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.activationStatus, activationStatus) || other.activationStatus == activationStatus)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,activationStatus,isAdmin,error);

@override
String toString() {
  return 'ActivationStatusState(isLoading: $isLoading, activationStatus: $activationStatus, isAdmin: $isAdmin, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ActivationStatusStateCopyWith<$Res> implements $ActivationStatusStateCopyWith<$Res> {
  factory _$ActivationStatusStateCopyWith(_ActivationStatusState value, $Res Function(_ActivationStatusState) _then) = __$ActivationStatusStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ActivationStatus? activationStatus, bool isAdmin, Failure? error
});




}
/// @nodoc
class __$ActivationStatusStateCopyWithImpl<$Res>
    implements _$ActivationStatusStateCopyWith<$Res> {
  __$ActivationStatusStateCopyWithImpl(this._self, this._then);

  final _ActivationStatusState _self;
  final $Res Function(_ActivationStatusState) _then;

/// Create a copy of ActivationStatusState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? activationStatus = freezed,Object? isAdmin = null,Object? error = freezed,}) {
  return _then(_ActivationStatusState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activationStatus: freezed == activationStatus ? _self.activationStatus : activationStatus // ignore: cast_nullable_to_non_nullable
as ActivationStatus?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
