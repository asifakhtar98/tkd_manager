// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationEvent()';
}


}

/// @nodoc
class $ActivationEventCopyWith<$Res>  {
$ActivationEventCopyWith(ActivationEvent _, $Res Function(ActivationEvent) __);
}


/// Adds pattern-matching-related methods to [ActivationEvent].
extension ActivationEventPatterns on ActivationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AddDays value)?  addDays,TResult Function( _ClearDays value)?  clearDays,TResult Function( _ContactNameChanged value)?  contactNameChanged,TResult Function( _SubmitRequested value)?  submitRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddDays() when addDays != null:
return addDays(_that);case _ClearDays() when clearDays != null:
return clearDays(_that);case _ContactNameChanged() when contactNameChanged != null:
return contactNameChanged(_that);case _SubmitRequested() when submitRequested != null:
return submitRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AddDays value)  addDays,required TResult Function( _ClearDays value)  clearDays,required TResult Function( _ContactNameChanged value)  contactNameChanged,required TResult Function( _SubmitRequested value)  submitRequested,}){
final _that = this;
switch (_that) {
case _AddDays():
return addDays(_that);case _ClearDays():
return clearDays(_that);case _ContactNameChanged():
return contactNameChanged(_that);case _SubmitRequested():
return submitRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AddDays value)?  addDays,TResult? Function( _ClearDays value)?  clearDays,TResult? Function( _ContactNameChanged value)?  contactNameChanged,TResult? Function( _SubmitRequested value)?  submitRequested,}){
final _that = this;
switch (_that) {
case _AddDays() when addDays != null:
return addDays(_that);case _ClearDays() when clearDays != null:
return clearDays(_that);case _ContactNameChanged() when contactNameChanged != null:
return contactNameChanged(_that);case _SubmitRequested() when submitRequested != null:
return submitRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int days)?  addDays,TResult Function()?  clearDays,TResult Function( String name)?  contactNameChanged,TResult Function()?  submitRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddDays() when addDays != null:
return addDays(_that.days);case _ClearDays() when clearDays != null:
return clearDays();case _ContactNameChanged() when contactNameChanged != null:
return contactNameChanged(_that.name);case _SubmitRequested() when submitRequested != null:
return submitRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int days)  addDays,required TResult Function()  clearDays,required TResult Function( String name)  contactNameChanged,required TResult Function()  submitRequested,}) {final _that = this;
switch (_that) {
case _AddDays():
return addDays(_that.days);case _ClearDays():
return clearDays();case _ContactNameChanged():
return contactNameChanged(_that.name);case _SubmitRequested():
return submitRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int days)?  addDays,TResult? Function()?  clearDays,TResult? Function( String name)?  contactNameChanged,TResult? Function()?  submitRequested,}) {final _that = this;
switch (_that) {
case _AddDays() when addDays != null:
return addDays(_that.days);case _ClearDays() when clearDays != null:
return clearDays();case _ContactNameChanged() when contactNameChanged != null:
return contactNameChanged(_that.name);case _SubmitRequested() when submitRequested != null:
return submitRequested();case _:
  return null;

}
}

}

/// @nodoc


class _AddDays implements ActivationEvent {
  const _AddDays(this.days);
  

 final  int days;

/// Create a copy of ActivationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddDaysCopyWith<_AddDays> get copyWith => __$AddDaysCopyWithImpl<_AddDays>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddDays&&(identical(other.days, days) || other.days == days));
}


@override
int get hashCode => Object.hash(runtimeType,days);

@override
String toString() {
  return 'ActivationEvent.addDays(days: $days)';
}


}

/// @nodoc
abstract mixin class _$AddDaysCopyWith<$Res> implements $ActivationEventCopyWith<$Res> {
  factory _$AddDaysCopyWith(_AddDays value, $Res Function(_AddDays) _then) = __$AddDaysCopyWithImpl;
@useResult
$Res call({
 int days
});




}
/// @nodoc
class __$AddDaysCopyWithImpl<$Res>
    implements _$AddDaysCopyWith<$Res> {
  __$AddDaysCopyWithImpl(this._self, this._then);

  final _AddDays _self;
  final $Res Function(_AddDays) _then;

/// Create a copy of ActivationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(_AddDays(
null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ClearDays implements ActivationEvent {
  const _ClearDays();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearDays);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationEvent.clearDays()';
}


}




/// @nodoc


class _ContactNameChanged implements ActivationEvent {
  const _ContactNameChanged(this.name);
  

 final  String name;

/// Create a copy of ActivationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactNameChangedCopyWith<_ContactNameChanged> get copyWith => __$ContactNameChangedCopyWithImpl<_ContactNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactNameChanged&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ActivationEvent.contactNameChanged(name: $name)';
}


}

/// @nodoc
abstract mixin class _$ContactNameChangedCopyWith<$Res> implements $ActivationEventCopyWith<$Res> {
  factory _$ContactNameChangedCopyWith(_ContactNameChanged value, $Res Function(_ContactNameChanged) _then) = __$ContactNameChangedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$ContactNameChangedCopyWithImpl<$Res>
    implements _$ContactNameChangedCopyWith<$Res> {
  __$ContactNameChangedCopyWithImpl(this._self, this._then);

  final _ContactNameChanged _self;
  final $Res Function(_ContactNameChanged) _then;

/// Create a copy of ActivationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_ContactNameChanged(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitRequested implements ActivationEvent {
  const _SubmitRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivationEvent.submitRequested()';
}


}




// dart format on
