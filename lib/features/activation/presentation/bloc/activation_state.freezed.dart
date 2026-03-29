// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationState {

 int get requestedDays; String get contactName; bool get isLoading; bool get isSuccess; Failure? get error;
/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationStateCopyWith<ActivationState> get copyWith => _$ActivationStateCopyWithImpl<ActivationState>(this as ActivationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationState&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,requestedDays,contactName,isLoading,isSuccess,error);

@override
String toString() {
  return 'ActivationState(requestedDays: $requestedDays, contactName: $contactName, isLoading: $isLoading, isSuccess: $isSuccess, error: $error)';
}


}

/// @nodoc
abstract mixin class $ActivationStateCopyWith<$Res>  {
  factory $ActivationStateCopyWith(ActivationState value, $Res Function(ActivationState) _then) = _$ActivationStateCopyWithImpl;
@useResult
$Res call({
 int requestedDays, String contactName, bool isLoading, bool isSuccess, Failure? error
});




}
/// @nodoc
class _$ActivationStateCopyWithImpl<$Res>
    implements $ActivationStateCopyWith<$Res> {
  _$ActivationStateCopyWithImpl(this._self, this._then);

  final ActivationState _self;
  final $Res Function(ActivationState) _then;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestedDays = null,Object? contactName = null,Object? isLoading = null,Object? isSuccess = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
requestedDays: null == requestedDays ? _self.requestedDays : requestedDays // ignore: cast_nullable_to_non_nullable
as int,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationState].
extension ActivationStatePatterns on ActivationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationState value)  $default,){
final _that = this;
switch (_that) {
case _ActivationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationState value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int requestedDays,  String contactName,  bool isLoading,  bool isSuccess,  Failure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
return $default(_that.requestedDays,_that.contactName,_that.isLoading,_that.isSuccess,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int requestedDays,  String contactName,  bool isLoading,  bool isSuccess,  Failure? error)  $default,) {final _that = this;
switch (_that) {
case _ActivationState():
return $default(_that.requestedDays,_that.contactName,_that.isLoading,_that.isSuccess,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int requestedDays,  String contactName,  bool isLoading,  bool isSuccess,  Failure? error)?  $default,) {final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
return $default(_that.requestedDays,_that.contactName,_that.isLoading,_that.isSuccess,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationState extends ActivationState {
  const _ActivationState({this.requestedDays = 0, this.contactName = '', this.isLoading = false, this.isSuccess = false, this.error}): super._();
  

@override@JsonKey() final  int requestedDays;
@override@JsonKey() final  String contactName;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSuccess;
@override final  Failure? error;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationStateCopyWith<_ActivationState> get copyWith => __$ActivationStateCopyWithImpl<_ActivationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationState&&(identical(other.requestedDays, requestedDays) || other.requestedDays == requestedDays)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,requestedDays,contactName,isLoading,isSuccess,error);

@override
String toString() {
  return 'ActivationState(requestedDays: $requestedDays, contactName: $contactName, isLoading: $isLoading, isSuccess: $isSuccess, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ActivationStateCopyWith<$Res> implements $ActivationStateCopyWith<$Res> {
  factory _$ActivationStateCopyWith(_ActivationState value, $Res Function(_ActivationState) _then) = __$ActivationStateCopyWithImpl;
@override @useResult
$Res call({
 int requestedDays, String contactName, bool isLoading, bool isSuccess, Failure? error
});




}
/// @nodoc
class __$ActivationStateCopyWithImpl<$Res>
    implements _$ActivationStateCopyWith<$Res> {
  __$ActivationStateCopyWithImpl(this._self, this._then);

  final _ActivationState _self;
  final $Res Function(_ActivationState) _then;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestedDays = null,Object? contactName = null,Object? isLoading = null,Object? isSuccess = null,Object? error = freezed,}) {
  return _then(_ActivationState(
requestedDays: null == requestedDays ? _self.requestedDays : requestedDays // ignore: cast_nullable_to_non_nullable
as int,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
