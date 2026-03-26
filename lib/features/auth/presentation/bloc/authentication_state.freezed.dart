// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState()';
}


}

/// @nodoc
class $AuthenticationStateCopyWith<$Res>  {
$AuthenticationStateCopyWith(AuthenticationState _, $Res Function(AuthenticationState) __);
}


/// Adds pattern-matching-related methods to [AuthenticationState].
extension AuthenticationStatePatterns on AuthenticationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthenticationUnknown value)?  unknown,TResult Function( AuthenticationAuthenticated value)?  authenticated,TResult Function( AuthenticationUnauthenticated value)?  unauthenticated,TResult Function( AuthenticationInProgress value)?  authenticationInProgress,TResult Function( AuthenticationFailureState value)?  authenticationFailure,TResult Function( AuthenticationPasswordResetEmailSent value)?  passwordResetEmailSent,TResult Function( AuthenticationEmailConfirmationSent value)?  emailConfirmationSent,TResult Function( AuthenticationPasswordRecoveryInProgress value)?  passwordRecoveryInProgress,TResult Function( AuthenticationEmailJustConfirmed value)?  emailJustConfirmed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthenticationUnknown() when unknown != null:
return unknown(_that);case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthenticationInProgress() when authenticationInProgress != null:
return authenticationInProgress(_that);case AuthenticationFailureState() when authenticationFailure != null:
return authenticationFailure(_that);case AuthenticationPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case AuthenticationEmailConfirmationSent() when emailConfirmationSent != null:
return emailConfirmationSent(_that);case AuthenticationPasswordRecoveryInProgress() when passwordRecoveryInProgress != null:
return passwordRecoveryInProgress(_that);case AuthenticationEmailJustConfirmed() when emailJustConfirmed != null:
return emailJustConfirmed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthenticationUnknown value)  unknown,required TResult Function( AuthenticationAuthenticated value)  authenticated,required TResult Function( AuthenticationUnauthenticated value)  unauthenticated,required TResult Function( AuthenticationInProgress value)  authenticationInProgress,required TResult Function( AuthenticationFailureState value)  authenticationFailure,required TResult Function( AuthenticationPasswordResetEmailSent value)  passwordResetEmailSent,required TResult Function( AuthenticationEmailConfirmationSent value)  emailConfirmationSent,required TResult Function( AuthenticationPasswordRecoveryInProgress value)  passwordRecoveryInProgress,required TResult Function( AuthenticationEmailJustConfirmed value)  emailJustConfirmed,}){
final _that = this;
switch (_that) {
case AuthenticationUnknown():
return unknown(_that);case AuthenticationAuthenticated():
return authenticated(_that);case AuthenticationUnauthenticated():
return unauthenticated(_that);case AuthenticationInProgress():
return authenticationInProgress(_that);case AuthenticationFailureState():
return authenticationFailure(_that);case AuthenticationPasswordResetEmailSent():
return passwordResetEmailSent(_that);case AuthenticationEmailConfirmationSent():
return emailConfirmationSent(_that);case AuthenticationPasswordRecoveryInProgress():
return passwordRecoveryInProgress(_that);case AuthenticationEmailJustConfirmed():
return emailJustConfirmed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthenticationUnknown value)?  unknown,TResult? Function( AuthenticationAuthenticated value)?  authenticated,TResult? Function( AuthenticationUnauthenticated value)?  unauthenticated,TResult? Function( AuthenticationInProgress value)?  authenticationInProgress,TResult? Function( AuthenticationFailureState value)?  authenticationFailure,TResult? Function( AuthenticationPasswordResetEmailSent value)?  passwordResetEmailSent,TResult? Function( AuthenticationEmailConfirmationSent value)?  emailConfirmationSent,TResult? Function( AuthenticationPasswordRecoveryInProgress value)?  passwordRecoveryInProgress,TResult? Function( AuthenticationEmailJustConfirmed value)?  emailJustConfirmed,}){
final _that = this;
switch (_that) {
case AuthenticationUnknown() when unknown != null:
return unknown(_that);case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthenticationInProgress() when authenticationInProgress != null:
return authenticationInProgress(_that);case AuthenticationFailureState() when authenticationFailure != null:
return authenticationFailure(_that);case AuthenticationPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case AuthenticationEmailConfirmationSent() when emailConfirmationSent != null:
return emailConfirmationSent(_that);case AuthenticationPasswordRecoveryInProgress() when passwordRecoveryInProgress != null:
return passwordRecoveryInProgress(_that);case AuthenticationEmailJustConfirmed() when emailJustConfirmed != null:
return emailJustConfirmed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( User user)?  authenticated,TResult Function()?  unauthenticated,TResult Function()?  authenticationInProgress,TResult Function( String message)?  authenticationFailure,TResult Function()?  passwordResetEmailSent,TResult Function()?  emailConfirmationSent,TResult Function()?  passwordRecoveryInProgress,TResult Function()?  emailJustConfirmed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthenticationUnknown() when unknown != null:
return unknown();case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthenticationInProgress() when authenticationInProgress != null:
return authenticationInProgress();case AuthenticationFailureState() when authenticationFailure != null:
return authenticationFailure(_that.message);case AuthenticationPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent();case AuthenticationEmailConfirmationSent() when emailConfirmationSent != null:
return emailConfirmationSent();case AuthenticationPasswordRecoveryInProgress() when passwordRecoveryInProgress != null:
return passwordRecoveryInProgress();case AuthenticationEmailJustConfirmed() when emailJustConfirmed != null:
return emailJustConfirmed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( User user)  authenticated,required TResult Function()  unauthenticated,required TResult Function()  authenticationInProgress,required TResult Function( String message)  authenticationFailure,required TResult Function()  passwordResetEmailSent,required TResult Function()  emailConfirmationSent,required TResult Function()  passwordRecoveryInProgress,required TResult Function()  emailJustConfirmed,}) {final _that = this;
switch (_that) {
case AuthenticationUnknown():
return unknown();case AuthenticationAuthenticated():
return authenticated(_that.user);case AuthenticationUnauthenticated():
return unauthenticated();case AuthenticationInProgress():
return authenticationInProgress();case AuthenticationFailureState():
return authenticationFailure(_that.message);case AuthenticationPasswordResetEmailSent():
return passwordResetEmailSent();case AuthenticationEmailConfirmationSent():
return emailConfirmationSent();case AuthenticationPasswordRecoveryInProgress():
return passwordRecoveryInProgress();case AuthenticationEmailJustConfirmed():
return emailJustConfirmed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( User user)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function()?  authenticationInProgress,TResult? Function( String message)?  authenticationFailure,TResult? Function()?  passwordResetEmailSent,TResult? Function()?  emailConfirmationSent,TResult? Function()?  passwordRecoveryInProgress,TResult? Function()?  emailJustConfirmed,}) {final _that = this;
switch (_that) {
case AuthenticationUnknown() when unknown != null:
return unknown();case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthenticationInProgress() when authenticationInProgress != null:
return authenticationInProgress();case AuthenticationFailureState() when authenticationFailure != null:
return authenticationFailure(_that.message);case AuthenticationPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent();case AuthenticationEmailConfirmationSent() when emailConfirmationSent != null:
return emailConfirmationSent();case AuthenticationPasswordRecoveryInProgress() when passwordRecoveryInProgress != null:
return passwordRecoveryInProgress();case AuthenticationEmailJustConfirmed() when emailJustConfirmed != null:
return emailJustConfirmed();case _:
  return null;

}
}

}

/// @nodoc


class AuthenticationUnknown implements AuthenticationState {
  const AuthenticationUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.unknown()';
}


}




/// @nodoc


class AuthenticationAuthenticated implements AuthenticationState {
  const AuthenticationAuthenticated({required this.user});
  

 final  User user;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationAuthenticatedCopyWith<AuthenticationAuthenticated> get copyWith => _$AuthenticationAuthenticatedCopyWithImpl<AuthenticationAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthenticationState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticationAuthenticatedCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationAuthenticatedCopyWith(AuthenticationAuthenticated value, $Res Function(AuthenticationAuthenticated) _then) = _$AuthenticationAuthenticatedCopyWithImpl;
@useResult
$Res call({
 User user
});




}
/// @nodoc
class _$AuthenticationAuthenticatedCopyWithImpl<$Res>
    implements $AuthenticationAuthenticatedCopyWith<$Res> {
  _$AuthenticationAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthenticationAuthenticated _self;
  final $Res Function(AuthenticationAuthenticated) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthenticationAuthenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}


}

/// @nodoc


class AuthenticationUnauthenticated implements AuthenticationState {
  const AuthenticationUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.unauthenticated()';
}


}




/// @nodoc


class AuthenticationInProgress implements AuthenticationState {
  const AuthenticationInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.authenticationInProgress()';
}


}




/// @nodoc


class AuthenticationFailureState implements AuthenticationState {
  const AuthenticationFailureState({required this.message});
  

 final  String message;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationFailureStateCopyWith<AuthenticationFailureState> get copyWith => _$AuthenticationFailureStateCopyWithImpl<AuthenticationFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationFailureState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthenticationState.authenticationFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthenticationFailureStateCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationFailureStateCopyWith(AuthenticationFailureState value, $Res Function(AuthenticationFailureState) _then) = _$AuthenticationFailureStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthenticationFailureStateCopyWithImpl<$Res>
    implements $AuthenticationFailureStateCopyWith<$Res> {
  _$AuthenticationFailureStateCopyWithImpl(this._self, this._then);

  final AuthenticationFailureState _self;
  final $Res Function(AuthenticationFailureState) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthenticationFailureState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationPasswordResetEmailSent implements AuthenticationState {
  const AuthenticationPasswordResetEmailSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationPasswordResetEmailSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.passwordResetEmailSent()';
}


}




/// @nodoc


class AuthenticationEmailConfirmationSent implements AuthenticationState {
  const AuthenticationEmailConfirmationSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEmailConfirmationSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.emailConfirmationSent()';
}


}




/// @nodoc


class AuthenticationPasswordRecoveryInProgress implements AuthenticationState {
  const AuthenticationPasswordRecoveryInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationPasswordRecoveryInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.passwordRecoveryInProgress()';
}


}




/// @nodoc


class AuthenticationEmailJustConfirmed implements AuthenticationState {
  const AuthenticationEmailJustConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEmailJustConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.emailJustConfirmed()';
}


}




// dart format on
