// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_status_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationStatusEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationStatusEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationStatusEvent()';
}


}

/// @nodoc
class $ActivationStatusEventCopyWith<$Res>  {
$ActivationStatusEventCopyWith(ActivationStatusEvent _, $Res Function(ActivationStatusEvent) __);
}


/// Adds pattern-matching-related methods to [ActivationStatusEvent].
extension ActivationStatusEventPatterns on ActivationStatusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ActivationStatusLoadRequested value)?  loadRequested,TResult Function( ActivationStatusAdminCheckRequested value)?  adminCheckRequested,TResult Function( ActivationStatusClearRequested value)?  clearRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ActivationStatusLoadRequested() when loadRequested != null:
return loadRequested(_that);case ActivationStatusAdminCheckRequested() when adminCheckRequested != null:
return adminCheckRequested(_that);case ActivationStatusClearRequested() when clearRequested != null:
return clearRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ActivationStatusLoadRequested value)  loadRequested,required TResult Function( ActivationStatusAdminCheckRequested value)  adminCheckRequested,required TResult Function( ActivationStatusClearRequested value)  clearRequested,}){
final _that = this;
switch (_that) {
case ActivationStatusLoadRequested():
return loadRequested(_that);case ActivationStatusAdminCheckRequested():
return adminCheckRequested(_that);case ActivationStatusClearRequested():
return clearRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ActivationStatusLoadRequested value)?  loadRequested,TResult? Function( ActivationStatusAdminCheckRequested value)?  adminCheckRequested,TResult? Function( ActivationStatusClearRequested value)?  clearRequested,}){
final _that = this;
switch (_that) {
case ActivationStatusLoadRequested() when loadRequested != null:
return loadRequested(_that);case ActivationStatusAdminCheckRequested() when adminCheckRequested != null:
return adminCheckRequested(_that);case ActivationStatusClearRequested() when clearRequested != null:
return clearRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function()?  adminCheckRequested,TResult Function()?  clearRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ActivationStatusLoadRequested() when loadRequested != null:
return loadRequested();case ActivationStatusAdminCheckRequested() when adminCheckRequested != null:
return adminCheckRequested();case ActivationStatusClearRequested() when clearRequested != null:
return clearRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function()  adminCheckRequested,required TResult Function()  clearRequested,}) {final _that = this;
switch (_that) {
case ActivationStatusLoadRequested():
return loadRequested();case ActivationStatusAdminCheckRequested():
return adminCheckRequested();case ActivationStatusClearRequested():
return clearRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function()?  adminCheckRequested,TResult? Function()?  clearRequested,}) {final _that = this;
switch (_that) {
case ActivationStatusLoadRequested() when loadRequested != null:
return loadRequested();case ActivationStatusAdminCheckRequested() when adminCheckRequested != null:
return adminCheckRequested();case ActivationStatusClearRequested() when clearRequested != null:
return clearRequested();case _:
  return null;

}
}

}

/// @nodoc


class ActivationStatusLoadRequested implements ActivationStatusEvent {
  const ActivationStatusLoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationStatusLoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationStatusEvent.loadRequested()';
}


}




/// @nodoc


class ActivationStatusAdminCheckRequested implements ActivationStatusEvent {
  const ActivationStatusAdminCheckRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationStatusAdminCheckRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationStatusEvent.adminCheckRequested()';
}


}




/// @nodoc


class ActivationStatusClearRequested implements ActivationStatusEvent {
  const ActivationStatusClearRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationStatusClearRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationStatusEvent.clearRequested()';
}


}




// dart format on
