// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEvent {

 String get newOrganizationName;
/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEventCopyWith<ProfileEvent> get copyWith => _$ProfileEventCopyWithImpl<ProfileEvent>(this as ProfileEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent&&(identical(other.newOrganizationName, newOrganizationName) || other.newOrganizationName == newOrganizationName));
}


@override
int get hashCode => Object.hash(runtimeType,newOrganizationName);

@override
String toString() {
  return 'ProfileEvent(newOrganizationName: $newOrganizationName)';
}


}

/// @nodoc
abstract mixin class $ProfileEventCopyWith<$Res>  {
  factory $ProfileEventCopyWith(ProfileEvent value, $Res Function(ProfileEvent) _then) = _$ProfileEventCopyWithImpl;
@useResult
$Res call({
 String newOrganizationName
});




}
/// @nodoc
class _$ProfileEventCopyWithImpl<$Res>
    implements $ProfileEventCopyWith<$Res> {
  _$ProfileEventCopyWithImpl(this._self, this._then);

  final ProfileEvent _self;
  final $Res Function(ProfileEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? newOrganizationName = null,}) {
  return _then(_self.copyWith(
newOrganizationName: null == newOrganizationName ? _self.newOrganizationName : newOrganizationName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfileUpdateOrganizationRequested value)?  updateOrganizationRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested() when updateOrganizationRequested != null:
return updateOrganizationRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfileUpdateOrganizationRequested value)  updateOrganizationRequested,}){
final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested():
return updateOrganizationRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfileUpdateOrganizationRequested value)?  updateOrganizationRequested,}){
final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested() when updateOrganizationRequested != null:
return updateOrganizationRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String newOrganizationName)?  updateOrganizationRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested() when updateOrganizationRequested != null:
return updateOrganizationRequested(_that.newOrganizationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String newOrganizationName)  updateOrganizationRequested,}) {final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested():
return updateOrganizationRequested(_that.newOrganizationName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String newOrganizationName)?  updateOrganizationRequested,}) {final _that = this;
switch (_that) {
case ProfileUpdateOrganizationRequested() when updateOrganizationRequested != null:
return updateOrganizationRequested(_that.newOrganizationName);case _:
  return null;

}
}

}

/// @nodoc


class ProfileUpdateOrganizationRequested implements ProfileEvent {
  const ProfileUpdateOrganizationRequested({required this.newOrganizationName});
  

@override final  String newOrganizationName;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdateOrganizationRequestedCopyWith<ProfileUpdateOrganizationRequested> get copyWith => _$ProfileUpdateOrganizationRequestedCopyWithImpl<ProfileUpdateOrganizationRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateOrganizationRequested&&(identical(other.newOrganizationName, newOrganizationName) || other.newOrganizationName == newOrganizationName));
}


@override
int get hashCode => Object.hash(runtimeType,newOrganizationName);

@override
String toString() {
  return 'ProfileEvent.updateOrganizationRequested(newOrganizationName: $newOrganizationName)';
}


}

/// @nodoc
abstract mixin class $ProfileUpdateOrganizationRequestedCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $ProfileUpdateOrganizationRequestedCopyWith(ProfileUpdateOrganizationRequested value, $Res Function(ProfileUpdateOrganizationRequested) _then) = _$ProfileUpdateOrganizationRequestedCopyWithImpl;
@override @useResult
$Res call({
 String newOrganizationName
});




}
/// @nodoc
class _$ProfileUpdateOrganizationRequestedCopyWithImpl<$Res>
    implements $ProfileUpdateOrganizationRequestedCopyWith<$Res> {
  _$ProfileUpdateOrganizationRequestedCopyWithImpl(this._self, this._then);

  final ProfileUpdateOrganizationRequested _self;
  final $Res Function(ProfileUpdateOrganizationRequested) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newOrganizationName = null,}) {
  return _then(ProfileUpdateOrganizationRequested(
newOrganizationName: null == newOrganizationName ? _self.newOrganizationName : newOrganizationName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
