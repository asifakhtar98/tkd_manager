// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignUpResult()';
}


}

/// @nodoc
class $SignUpResultCopyWith<$Res>  {
$SignUpResultCopyWith(SignUpResult _, $Res Function(SignUpResult) __);
}


/// Adds pattern-matching-related methods to [SignUpResult].
extension SignUpResultPatterns on SignUpResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignUpAuthenticated value)?  authenticated,TResult Function( SignUpConfirmationRequired value)?  confirmationRequired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignUpAuthenticated() when authenticated != null:
return authenticated(_that);case SignUpConfirmationRequired() when confirmationRequired != null:
return confirmationRequired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignUpAuthenticated value)  authenticated,required TResult Function( SignUpConfirmationRequired value)  confirmationRequired,}){
final _that = this;
switch (_that) {
case SignUpAuthenticated():
return authenticated(_that);case SignUpConfirmationRequired():
return confirmationRequired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignUpAuthenticated value)?  authenticated,TResult? Function( SignUpConfirmationRequired value)?  confirmationRequired,}){
final _that = this;
switch (_that) {
case SignUpAuthenticated() when authenticated != null:
return authenticated(_that);case SignUpConfirmationRequired() when confirmationRequired != null:
return confirmationRequired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( User user)?  authenticated,TResult Function()?  confirmationRequired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignUpAuthenticated() when authenticated != null:
return authenticated(_that.user);case SignUpConfirmationRequired() when confirmationRequired != null:
return confirmationRequired();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( User user)  authenticated,required TResult Function()  confirmationRequired,}) {final _that = this;
switch (_that) {
case SignUpAuthenticated():
return authenticated(_that.user);case SignUpConfirmationRequired():
return confirmationRequired();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( User user)?  authenticated,TResult? Function()?  confirmationRequired,}) {final _that = this;
switch (_that) {
case SignUpAuthenticated() when authenticated != null:
return authenticated(_that.user);case SignUpConfirmationRequired() when confirmationRequired != null:
return confirmationRequired();case _:
  return null;

}
}

}

/// @nodoc


class SignUpAuthenticated implements SignUpResult {
  const SignUpAuthenticated({required this.user});
  

 final  User user;

/// Create a copy of SignUpResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpAuthenticatedCopyWith<SignUpAuthenticated> get copyWith => _$SignUpAuthenticatedCopyWithImpl<SignUpAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'SignUpResult.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $SignUpAuthenticatedCopyWith<$Res> implements $SignUpResultCopyWith<$Res> {
  factory $SignUpAuthenticatedCopyWith(SignUpAuthenticated value, $Res Function(SignUpAuthenticated) _then) = _$SignUpAuthenticatedCopyWithImpl;
@useResult
$Res call({
 User user
});




}
/// @nodoc
class _$SignUpAuthenticatedCopyWithImpl<$Res>
    implements $SignUpAuthenticatedCopyWith<$Res> {
  _$SignUpAuthenticatedCopyWithImpl(this._self, this._then);

  final SignUpAuthenticated _self;
  final $Res Function(SignUpAuthenticated) _then;

/// Create a copy of SignUpResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(SignUpAuthenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}


}

/// @nodoc


class SignUpConfirmationRequired implements SignUpResult {
  const SignUpConfirmationRequired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpConfirmationRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignUpResult.confirmationRequired()';
}


}




// dart format on
