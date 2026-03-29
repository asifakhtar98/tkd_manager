// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_activation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminActivationState {

 bool get isLoading; List<ActivationRequestEntity> get pendingRequests;/// Set of request IDs currently being processed (approve/reject in flight).
 Set<String> get processingRequestIds; Failure? get error;/// Transient success message, e.g. "Request approved successfully".
 String? get successMessage;
/// Create a copy of AdminActivationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminActivationStateCopyWith<AdminActivationState> get copyWith => _$AdminActivationStateCopyWithImpl<AdminActivationState>(this as AdminActivationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminActivationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.pendingRequests, pendingRequests)&&const DeepCollectionEquality().equals(other.processingRequestIds, processingRequestIds)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(pendingRequests),const DeepCollectionEquality().hash(processingRequestIds),error,successMessage);

@override
String toString() {
  return 'AdminActivationState(isLoading: $isLoading, pendingRequests: $pendingRequests, processingRequestIds: $processingRequestIds, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $AdminActivationStateCopyWith<$Res>  {
  factory $AdminActivationStateCopyWith(AdminActivationState value, $Res Function(AdminActivationState) _then) = _$AdminActivationStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ActivationRequestEntity> pendingRequests, Set<String> processingRequestIds, Failure? error, String? successMessage
});




}
/// @nodoc
class _$AdminActivationStateCopyWithImpl<$Res>
    implements $AdminActivationStateCopyWith<$Res> {
  _$AdminActivationStateCopyWithImpl(this._self, this._then);

  final AdminActivationState _self;
  final $Res Function(AdminActivationState) _then;

/// Create a copy of AdminActivationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? pendingRequests = null,Object? processingRequestIds = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,pendingRequests: null == pendingRequests ? _self.pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<ActivationRequestEntity>,processingRequestIds: null == processingRequestIds ? _self.processingRequestIds : processingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminActivationState].
extension AdminActivationStatePatterns on AdminActivationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminActivationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminActivationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminActivationState value)  $default,){
final _that = this;
switch (_that) {
case _AdminActivationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminActivationState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminActivationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ActivationRequestEntity> pendingRequests,  Set<String> processingRequestIds,  Failure? error,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminActivationState() when $default != null:
return $default(_that.isLoading,_that.pendingRequests,_that.processingRequestIds,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ActivationRequestEntity> pendingRequests,  Set<String> processingRequestIds,  Failure? error,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _AdminActivationState():
return $default(_that.isLoading,_that.pendingRequests,_that.processingRequestIds,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ActivationRequestEntity> pendingRequests,  Set<String> processingRequestIds,  Failure? error,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _AdminActivationState() when $default != null:
return $default(_that.isLoading,_that.pendingRequests,_that.processingRequestIds,_that.error,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AdminActivationState implements AdminActivationState {
  const _AdminActivationState({this.isLoading = true, final  List<ActivationRequestEntity> pendingRequests = const [], final  Set<String> processingRequestIds = const {}, this.error, this.successMessage}): _pendingRequests = pendingRequests,_processingRequestIds = processingRequestIds;
  

@override@JsonKey() final  bool isLoading;
 final  List<ActivationRequestEntity> _pendingRequests;
@override@JsonKey() List<ActivationRequestEntity> get pendingRequests {
  if (_pendingRequests is EqualUnmodifiableListView) return _pendingRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingRequests);
}

/// Set of request IDs currently being processed (approve/reject in flight).
 final  Set<String> _processingRequestIds;
/// Set of request IDs currently being processed (approve/reject in flight).
@override@JsonKey() Set<String> get processingRequestIds {
  if (_processingRequestIds is EqualUnmodifiableSetView) return _processingRequestIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_processingRequestIds);
}

@override final  Failure? error;
/// Transient success message, e.g. "Request approved successfully".
@override final  String? successMessage;

/// Create a copy of AdminActivationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminActivationStateCopyWith<_AdminActivationState> get copyWith => __$AdminActivationStateCopyWithImpl<_AdminActivationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminActivationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._pendingRequests, _pendingRequests)&&const DeepCollectionEquality().equals(other._processingRequestIds, _processingRequestIds)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_pendingRequests),const DeepCollectionEquality().hash(_processingRequestIds),error,successMessage);

@override
String toString() {
  return 'AdminActivationState(isLoading: $isLoading, pendingRequests: $pendingRequests, processingRequestIds: $processingRequestIds, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$AdminActivationStateCopyWith<$Res> implements $AdminActivationStateCopyWith<$Res> {
  factory _$AdminActivationStateCopyWith(_AdminActivationState value, $Res Function(_AdminActivationState) _then) = __$AdminActivationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ActivationRequestEntity> pendingRequests, Set<String> processingRequestIds, Failure? error, String? successMessage
});




}
/// @nodoc
class __$AdminActivationStateCopyWithImpl<$Res>
    implements _$AdminActivationStateCopyWith<$Res> {
  __$AdminActivationStateCopyWithImpl(this._self, this._then);

  final _AdminActivationState _self;
  final $Res Function(_AdminActivationState) _then;

/// Create a copy of AdminActivationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? pendingRequests = null,Object? processingRequestIds = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_AdminActivationState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,pendingRequests: null == pendingRequests ? _self._pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<ActivationRequestEntity>,processingRequestIds: null == processingRequestIds ? _self._processingRequestIds : processingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
