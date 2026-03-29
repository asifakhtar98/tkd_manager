// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState()';
}


}

/// @nodoc
class $ProfileStateCopyWith<$Res>  {
$ProfileStateCopyWith(ProfileState _, $Res Function(ProfileState) __);
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfileInitial value)?  initial,TResult Function( ProfileUpdateInProgress value)?  updateInProgress,TResult Function( ProfileUpdateFailure value)?  updateFailure,TResult Function( ProfileUpdateSuccess value)?  updateSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileUpdateInProgress() when updateInProgress != null:
return updateInProgress(_that);case ProfileUpdateFailure() when updateFailure != null:
return updateFailure(_that);case ProfileUpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfileInitial value)  initial,required TResult Function( ProfileUpdateInProgress value)  updateInProgress,required TResult Function( ProfileUpdateFailure value)  updateFailure,required TResult Function( ProfileUpdateSuccess value)  updateSuccess,}){
final _that = this;
switch (_that) {
case ProfileInitial():
return initial(_that);case ProfileUpdateInProgress():
return updateInProgress(_that);case ProfileUpdateFailure():
return updateFailure(_that);case ProfileUpdateSuccess():
return updateSuccess(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfileInitial value)?  initial,TResult? Function( ProfileUpdateInProgress value)?  updateInProgress,TResult? Function( ProfileUpdateFailure value)?  updateFailure,TResult? Function( ProfileUpdateSuccess value)?  updateSuccess,}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileUpdateInProgress() when updateInProgress != null:
return updateInProgress(_that);case ProfileUpdateFailure() when updateFailure != null:
return updateFailure(_that);case ProfileUpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  updateInProgress,TResult Function( String message)?  updateFailure,TResult Function()?  updateSuccess,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileUpdateInProgress() when updateInProgress != null:
return updateInProgress();case ProfileUpdateFailure() when updateFailure != null:
return updateFailure(_that.message);case ProfileUpdateSuccess() when updateSuccess != null:
return updateSuccess();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  updateInProgress,required TResult Function( String message)  updateFailure,required TResult Function()  updateSuccess,}) {final _that = this;
switch (_that) {
case ProfileInitial():
return initial();case ProfileUpdateInProgress():
return updateInProgress();case ProfileUpdateFailure():
return updateFailure(_that.message);case ProfileUpdateSuccess():
return updateSuccess();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  updateInProgress,TResult? Function( String message)?  updateFailure,TResult? Function()?  updateSuccess,}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileUpdateInProgress() when updateInProgress != null:
return updateInProgress();case ProfileUpdateFailure() when updateFailure != null:
return updateFailure(_that.message);case ProfileUpdateSuccess() when updateSuccess != null:
return updateSuccess();case _:
  return null;

}
}

}

/// @nodoc


class ProfileInitial implements ProfileState {
  const ProfileInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.initial()';
}


}




/// @nodoc


class ProfileUpdateInProgress implements ProfileState {
  const ProfileUpdateInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.updateInProgress()';
}


}




/// @nodoc


class ProfileUpdateFailure implements ProfileState {
  const ProfileUpdateFailure({required this.message});
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdateFailureCopyWith<ProfileUpdateFailure> get copyWith => _$ProfileUpdateFailureCopyWithImpl<ProfileUpdateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.updateFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileUpdateFailureCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileUpdateFailureCopyWith(ProfileUpdateFailure value, $Res Function(ProfileUpdateFailure) _then) = _$ProfileUpdateFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProfileUpdateFailureCopyWithImpl<$Res>
    implements $ProfileUpdateFailureCopyWith<$Res> {
  _$ProfileUpdateFailureCopyWithImpl(this._self, this._then);

  final ProfileUpdateFailure _self;
  final $Res Function(ProfileUpdateFailure) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProfileUpdateFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProfileUpdateSuccess implements ProfileState {
  const ProfileUpdateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.updateSuccess()';
}


}




// dart format on
