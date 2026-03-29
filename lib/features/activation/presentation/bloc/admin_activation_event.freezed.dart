// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_activation_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminActivationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminActivationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminActivationEvent()';
}


}

/// @nodoc
class $AdminActivationEventCopyWith<$Res>  {
$AdminActivationEventCopyWith(AdminActivationEvent _, $Res Function(AdminActivationEvent) __);
}


/// Adds pattern-matching-related methods to [AdminActivationEvent].
extension AdminActivationEventPatterns on AdminActivationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AdminActivationLoadPendingRequests value)?  loadPendingRequests,TResult Function( AdminActivationApproveRequest value)?  approveRequest,TResult Function( AdminActivationRejectRequest value)?  rejectRequest,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests() when loadPendingRequests != null:
return loadPendingRequests(_that);case AdminActivationApproveRequest() when approveRequest != null:
return approveRequest(_that);case AdminActivationRejectRequest() when rejectRequest != null:
return rejectRequest(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AdminActivationLoadPendingRequests value)  loadPendingRequests,required TResult Function( AdminActivationApproveRequest value)  approveRequest,required TResult Function( AdminActivationRejectRequest value)  rejectRequest,}){
final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests():
return loadPendingRequests(_that);case AdminActivationApproveRequest():
return approveRequest(_that);case AdminActivationRejectRequest():
return rejectRequest(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AdminActivationLoadPendingRequests value)?  loadPendingRequests,TResult? Function( AdminActivationApproveRequest value)?  approveRequest,TResult? Function( AdminActivationRejectRequest value)?  rejectRequest,}){
final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests() when loadPendingRequests != null:
return loadPendingRequests(_that);case AdminActivationApproveRequest() when approveRequest != null:
return approveRequest(_that);case AdminActivationRejectRequest() when rejectRequest != null:
return rejectRequest(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadPendingRequests,TResult Function( ActivationRequestEntity request)?  approveRequest,TResult Function( String requestId)?  rejectRequest,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests() when loadPendingRequests != null:
return loadPendingRequests();case AdminActivationApproveRequest() when approveRequest != null:
return approveRequest(_that.request);case AdminActivationRejectRequest() when rejectRequest != null:
return rejectRequest(_that.requestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadPendingRequests,required TResult Function( ActivationRequestEntity request)  approveRequest,required TResult Function( String requestId)  rejectRequest,}) {final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests():
return loadPendingRequests();case AdminActivationApproveRequest():
return approveRequest(_that.request);case AdminActivationRejectRequest():
return rejectRequest(_that.requestId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadPendingRequests,TResult? Function( ActivationRequestEntity request)?  approveRequest,TResult? Function( String requestId)?  rejectRequest,}) {final _that = this;
switch (_that) {
case AdminActivationLoadPendingRequests() when loadPendingRequests != null:
return loadPendingRequests();case AdminActivationApproveRequest() when approveRequest != null:
return approveRequest(_that.request);case AdminActivationRejectRequest() when rejectRequest != null:
return rejectRequest(_that.requestId);case _:
  return null;

}
}

}

/// @nodoc


class AdminActivationLoadPendingRequests implements AdminActivationEvent {
  const AdminActivationLoadPendingRequests();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminActivationLoadPendingRequests);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminActivationEvent.loadPendingRequests()';
}


}




/// @nodoc


class AdminActivationApproveRequest implements AdminActivationEvent {
  const AdminActivationApproveRequest(this.request);
  

 final  ActivationRequestEntity request;

/// Create a copy of AdminActivationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminActivationApproveRequestCopyWith<AdminActivationApproveRequest> get copyWith => _$AdminActivationApproveRequestCopyWithImpl<AdminActivationApproveRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminActivationApproveRequest&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,request);

@override
String toString() {
  return 'AdminActivationEvent.approveRequest(request: $request)';
}


}

/// @nodoc
abstract mixin class $AdminActivationApproveRequestCopyWith<$Res> implements $AdminActivationEventCopyWith<$Res> {
  factory $AdminActivationApproveRequestCopyWith(AdminActivationApproveRequest value, $Res Function(AdminActivationApproveRequest) _then) = _$AdminActivationApproveRequestCopyWithImpl;
@useResult
$Res call({
 ActivationRequestEntity request
});


$ActivationRequestEntityCopyWith<$Res> get request;

}
/// @nodoc
class _$AdminActivationApproveRequestCopyWithImpl<$Res>
    implements $AdminActivationApproveRequestCopyWith<$Res> {
  _$AdminActivationApproveRequestCopyWithImpl(this._self, this._then);

  final AdminActivationApproveRequest _self;
  final $Res Function(AdminActivationApproveRequest) _then;

/// Create a copy of AdminActivationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,}) {
  return _then(AdminActivationApproveRequest(
null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as ActivationRequestEntity,
  ));
}

/// Create a copy of AdminActivationEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationRequestEntityCopyWith<$Res> get request {
  
  return $ActivationRequestEntityCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class AdminActivationRejectRequest implements AdminActivationEvent {
  const AdminActivationRejectRequest(this.requestId);
  

 final  String requestId;

/// Create a copy of AdminActivationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminActivationRejectRequestCopyWith<AdminActivationRejectRequest> get copyWith => _$AdminActivationRejectRequestCopyWithImpl<AdminActivationRejectRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminActivationRejectRequest&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,requestId);

@override
String toString() {
  return 'AdminActivationEvent.rejectRequest(requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $AdminActivationRejectRequestCopyWith<$Res> implements $AdminActivationEventCopyWith<$Res> {
  factory $AdminActivationRejectRequestCopyWith(AdminActivationRejectRequest value, $Res Function(AdminActivationRejectRequest) _then) = _$AdminActivationRejectRequestCopyWithImpl;
@useResult
$Res call({
 String requestId
});




}
/// @nodoc
class _$AdminActivationRejectRequestCopyWithImpl<$Res>
    implements $AdminActivationRejectRequestCopyWith<$Res> {
  _$AdminActivationRejectRequestCopyWithImpl(this._self, this._then);

  final AdminActivationRejectRequest _self;
  final $Res Function(AdminActivationRejectRequest) _then;

/// Create a copy of AdminActivationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requestId = null,}) {
  return _then(AdminActivationRejectRequest(
null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
