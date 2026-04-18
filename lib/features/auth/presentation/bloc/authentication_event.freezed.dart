// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent()';
}


}

/// @nodoc
class $AuthenticationEventCopyWith<$Res>  {
$AuthenticationEventCopyWith(AuthenticationEvent _, $Res Function(AuthenticationEvent) __);
}


/// Adds pattern-matching-related methods to [AuthenticationEvent].
extension AuthenticationEventPatterns on AuthenticationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthenticationSubscriptionRequested value)?  subscriptionRequested,TResult Function( AuthenticationSignInRequested value)?  signInRequested,TResult Function( AuthenticationSignUpRequested value)?  signUpRequested,TResult Function( AuthenticationSignOutRequested value)?  signOutRequested,TResult Function( AuthenticationPasswordResetRequested value)?  passwordResetRequested,TResult Function( AuthenticationPasswordUpdateRequested value)?  passwordUpdateRequested,TResult Function( AuthenticationStatusChanged value)?  statusChanged,TResult Function( AuthenticationPasswordRecoveryDetected value)?  passwordRecoveryDetected,TResult Function( AuthenticationEmailConfirmationDetected value)?  emailConfirmationDetected,TResult Function( AuthenticationEmailConfirmationAcknowledged value)?  emailConfirmationAcknowledged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case AuthenticationSignInRequested() when signInRequested != null:
return signInRequested(_that);case AuthenticationSignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case AuthenticationSignOutRequested() when signOutRequested != null:
return signOutRequested(_that);case AuthenticationPasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that);case AuthenticationPasswordUpdateRequested() when passwordUpdateRequested != null:
return passwordUpdateRequested(_that);case AuthenticationStatusChanged() when statusChanged != null:
return statusChanged(_that);case AuthenticationPasswordRecoveryDetected() when passwordRecoveryDetected != null:
return passwordRecoveryDetected(_that);case AuthenticationEmailConfirmationDetected() when emailConfirmationDetected != null:
return emailConfirmationDetected(_that);case AuthenticationEmailConfirmationAcknowledged() when emailConfirmationAcknowledged != null:
return emailConfirmationAcknowledged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthenticationSubscriptionRequested value)  subscriptionRequested,required TResult Function( AuthenticationSignInRequested value)  signInRequested,required TResult Function( AuthenticationSignUpRequested value)  signUpRequested,required TResult Function( AuthenticationSignOutRequested value)  signOutRequested,required TResult Function( AuthenticationPasswordResetRequested value)  passwordResetRequested,required TResult Function( AuthenticationPasswordUpdateRequested value)  passwordUpdateRequested,required TResult Function( AuthenticationStatusChanged value)  statusChanged,required TResult Function( AuthenticationPasswordRecoveryDetected value)  passwordRecoveryDetected,required TResult Function( AuthenticationEmailConfirmationDetected value)  emailConfirmationDetected,required TResult Function( AuthenticationEmailConfirmationAcknowledged value)  emailConfirmationAcknowledged,}){
final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested():
return subscriptionRequested(_that);case AuthenticationSignInRequested():
return signInRequested(_that);case AuthenticationSignUpRequested():
return signUpRequested(_that);case AuthenticationSignOutRequested():
return signOutRequested(_that);case AuthenticationPasswordResetRequested():
return passwordResetRequested(_that);case AuthenticationPasswordUpdateRequested():
return passwordUpdateRequested(_that);case AuthenticationStatusChanged():
return statusChanged(_that);case AuthenticationPasswordRecoveryDetected():
return passwordRecoveryDetected(_that);case AuthenticationEmailConfirmationDetected():
return emailConfirmationDetected(_that);case AuthenticationEmailConfirmationAcknowledged():
return emailConfirmationAcknowledged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthenticationSubscriptionRequested value)?  subscriptionRequested,TResult? Function( AuthenticationSignInRequested value)?  signInRequested,TResult? Function( AuthenticationSignUpRequested value)?  signUpRequested,TResult? Function( AuthenticationSignOutRequested value)?  signOutRequested,TResult? Function( AuthenticationPasswordResetRequested value)?  passwordResetRequested,TResult? Function( AuthenticationPasswordUpdateRequested value)?  passwordUpdateRequested,TResult? Function( AuthenticationStatusChanged value)?  statusChanged,TResult? Function( AuthenticationPasswordRecoveryDetected value)?  passwordRecoveryDetected,TResult? Function( AuthenticationEmailConfirmationDetected value)?  emailConfirmationDetected,TResult? Function( AuthenticationEmailConfirmationAcknowledged value)?  emailConfirmationAcknowledged,}){
final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested(_that);case AuthenticationSignInRequested() when signInRequested != null:
return signInRequested(_that);case AuthenticationSignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case AuthenticationSignOutRequested() when signOutRequested != null:
return signOutRequested(_that);case AuthenticationPasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that);case AuthenticationPasswordUpdateRequested() when passwordUpdateRequested != null:
return passwordUpdateRequested(_that);case AuthenticationStatusChanged() when statusChanged != null:
return statusChanged(_that);case AuthenticationPasswordRecoveryDetected() when passwordRecoveryDetected != null:
return passwordRecoveryDetected(_that);case AuthenticationEmailConfirmationDetected() when emailConfirmationDetected != null:
return emailConfirmationDetected(_that);case AuthenticationEmailConfirmationAcknowledged() when emailConfirmationAcknowledged != null:
return emailConfirmationAcknowledged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  subscriptionRequested,TResult Function( String email,  String password)?  signInRequested,TResult Function( String email,  String password,  String organizationName)?  signUpRequested,TResult Function()?  signOutRequested,TResult Function( String email)?  passwordResetRequested,TResult Function( String newPassword)?  passwordUpdateRequested,TResult Function( User? user)?  statusChanged,TResult Function()?  passwordRecoveryDetected,TResult Function( bool performSignOut)?  emailConfirmationDetected,TResult Function()?  emailConfirmationAcknowledged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case AuthenticationSignInRequested() when signInRequested != null:
return signInRequested(_that.email,_that.password);case AuthenticationSignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.organizationName);case AuthenticationSignOutRequested() when signOutRequested != null:
return signOutRequested();case AuthenticationPasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that.email);case AuthenticationPasswordUpdateRequested() when passwordUpdateRequested != null:
return passwordUpdateRequested(_that.newPassword);case AuthenticationStatusChanged() when statusChanged != null:
return statusChanged(_that.user);case AuthenticationPasswordRecoveryDetected() when passwordRecoveryDetected != null:
return passwordRecoveryDetected();case AuthenticationEmailConfirmationDetected() when emailConfirmationDetected != null:
return emailConfirmationDetected(_that.performSignOut);case AuthenticationEmailConfirmationAcknowledged() when emailConfirmationAcknowledged != null:
return emailConfirmationAcknowledged();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  subscriptionRequested,required TResult Function( String email,  String password)  signInRequested,required TResult Function( String email,  String password,  String organizationName)  signUpRequested,required TResult Function()  signOutRequested,required TResult Function( String email)  passwordResetRequested,required TResult Function( String newPassword)  passwordUpdateRequested,required TResult Function( User? user)  statusChanged,required TResult Function()  passwordRecoveryDetected,required TResult Function( bool performSignOut)  emailConfirmationDetected,required TResult Function()  emailConfirmationAcknowledged,}) {final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested():
return subscriptionRequested();case AuthenticationSignInRequested():
return signInRequested(_that.email,_that.password);case AuthenticationSignUpRequested():
return signUpRequested(_that.email,_that.password,_that.organizationName);case AuthenticationSignOutRequested():
return signOutRequested();case AuthenticationPasswordResetRequested():
return passwordResetRequested(_that.email);case AuthenticationPasswordUpdateRequested():
return passwordUpdateRequested(_that.newPassword);case AuthenticationStatusChanged():
return statusChanged(_that.user);case AuthenticationPasswordRecoveryDetected():
return passwordRecoveryDetected();case AuthenticationEmailConfirmationDetected():
return emailConfirmationDetected(_that.performSignOut);case AuthenticationEmailConfirmationAcknowledged():
return emailConfirmationAcknowledged();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  subscriptionRequested,TResult? Function( String email,  String password)?  signInRequested,TResult? Function( String email,  String password,  String organizationName)?  signUpRequested,TResult? Function()?  signOutRequested,TResult? Function( String email)?  passwordResetRequested,TResult? Function( String newPassword)?  passwordUpdateRequested,TResult? Function( User? user)?  statusChanged,TResult? Function()?  passwordRecoveryDetected,TResult? Function( bool performSignOut)?  emailConfirmationDetected,TResult? Function()?  emailConfirmationAcknowledged,}) {final _that = this;
switch (_that) {
case AuthenticationSubscriptionRequested() when subscriptionRequested != null:
return subscriptionRequested();case AuthenticationSignInRequested() when signInRequested != null:
return signInRequested(_that.email,_that.password);case AuthenticationSignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.organizationName);case AuthenticationSignOutRequested() when signOutRequested != null:
return signOutRequested();case AuthenticationPasswordResetRequested() when passwordResetRequested != null:
return passwordResetRequested(_that.email);case AuthenticationPasswordUpdateRequested() when passwordUpdateRequested != null:
return passwordUpdateRequested(_that.newPassword);case AuthenticationStatusChanged() when statusChanged != null:
return statusChanged(_that.user);case AuthenticationPasswordRecoveryDetected() when passwordRecoveryDetected != null:
return passwordRecoveryDetected();case AuthenticationEmailConfirmationDetected() when emailConfirmationDetected != null:
return emailConfirmationDetected(_that.performSignOut);case AuthenticationEmailConfirmationAcknowledged() when emailConfirmationAcknowledged != null:
return emailConfirmationAcknowledged();case _:
  return null;

}
}

}

/// @nodoc


class AuthenticationSubscriptionRequested implements AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationSubscriptionRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.subscriptionRequested()';
}


}




/// @nodoc


class AuthenticationSignInRequested implements AuthenticationEvent {
  const AuthenticationSignInRequested({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationSignInRequestedCopyWith<AuthenticationSignInRequested> get copyWith => _$AuthenticationSignInRequestedCopyWithImpl<AuthenticationSignInRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationSignInRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthenticationEvent.signInRequested(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthenticationSignInRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationSignInRequestedCopyWith(AuthenticationSignInRequested value, $Res Function(AuthenticationSignInRequested) _then) = _$AuthenticationSignInRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$AuthenticationSignInRequestedCopyWithImpl<$Res>
    implements $AuthenticationSignInRequestedCopyWith<$Res> {
  _$AuthenticationSignInRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationSignInRequested _self;
  final $Res Function(AuthenticationSignInRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(AuthenticationSignInRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationSignUpRequested implements AuthenticationEvent {
  const AuthenticationSignUpRequested({required this.email, required this.password, required this.organizationName});
  

 final  String email;
 final  String password;
 final  String organizationName;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationSignUpRequestedCopyWith<AuthenticationSignUpRequested> get copyWith => _$AuthenticationSignUpRequestedCopyWithImpl<AuthenticationSignUpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationSignUpRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.organizationName, organizationName) || other.organizationName == organizationName));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,organizationName);

@override
String toString() {
  return 'AuthenticationEvent.signUpRequested(email: $email, password: $password, organizationName: $organizationName)';
}


}

/// @nodoc
abstract mixin class $AuthenticationSignUpRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationSignUpRequestedCopyWith(AuthenticationSignUpRequested value, $Res Function(AuthenticationSignUpRequested) _then) = _$AuthenticationSignUpRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password, String organizationName
});




}
/// @nodoc
class _$AuthenticationSignUpRequestedCopyWithImpl<$Res>
    implements $AuthenticationSignUpRequestedCopyWith<$Res> {
  _$AuthenticationSignUpRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationSignUpRequested _self;
  final $Res Function(AuthenticationSignUpRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? organizationName = null,}) {
  return _then(AuthenticationSignUpRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,organizationName: null == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationSignOutRequested implements AuthenticationEvent {
  const AuthenticationSignOutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationSignOutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.signOutRequested()';
}


}




/// @nodoc


class AuthenticationPasswordResetRequested implements AuthenticationEvent {
  const AuthenticationPasswordResetRequested({required this.email});
  

 final  String email;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationPasswordResetRequestedCopyWith<AuthenticationPasswordResetRequested> get copyWith => _$AuthenticationPasswordResetRequestedCopyWithImpl<AuthenticationPasswordResetRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationPasswordResetRequested&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthenticationEvent.passwordResetRequested(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthenticationPasswordResetRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationPasswordResetRequestedCopyWith(AuthenticationPasswordResetRequested value, $Res Function(AuthenticationPasswordResetRequested) _then) = _$AuthenticationPasswordResetRequestedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthenticationPasswordResetRequestedCopyWithImpl<$Res>
    implements $AuthenticationPasswordResetRequestedCopyWith<$Res> {
  _$AuthenticationPasswordResetRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationPasswordResetRequested _self;
  final $Res Function(AuthenticationPasswordResetRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthenticationPasswordResetRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationPasswordUpdateRequested implements AuthenticationEvent {
  const AuthenticationPasswordUpdateRequested({required this.newPassword});
  

 final  String newPassword;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationPasswordUpdateRequestedCopyWith<AuthenticationPasswordUpdateRequested> get copyWith => _$AuthenticationPasswordUpdateRequestedCopyWithImpl<AuthenticationPasswordUpdateRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationPasswordUpdateRequested&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode => Object.hash(runtimeType,newPassword);

@override
String toString() {
  return 'AuthenticationEvent.passwordUpdateRequested(newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class $AuthenticationPasswordUpdateRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationPasswordUpdateRequestedCopyWith(AuthenticationPasswordUpdateRequested value, $Res Function(AuthenticationPasswordUpdateRequested) _then) = _$AuthenticationPasswordUpdateRequestedCopyWithImpl;
@useResult
$Res call({
 String newPassword
});




}
/// @nodoc
class _$AuthenticationPasswordUpdateRequestedCopyWithImpl<$Res>
    implements $AuthenticationPasswordUpdateRequestedCopyWith<$Res> {
  _$AuthenticationPasswordUpdateRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationPasswordUpdateRequested _self;
  final $Res Function(AuthenticationPasswordUpdateRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newPassword = null,}) {
  return _then(AuthenticationPasswordUpdateRequested(
newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@internal
class AuthenticationStatusChanged implements AuthenticationEvent {
  const AuthenticationStatusChanged({required this.user});
  

 final  User? user;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationStatusChangedCopyWith<AuthenticationStatusChanged> get copyWith => _$AuthenticationStatusChangedCopyWithImpl<AuthenticationStatusChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationStatusChanged&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthenticationEvent.statusChanged(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticationStatusChangedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationStatusChangedCopyWith(AuthenticationStatusChanged value, $Res Function(AuthenticationStatusChanged) _then) = _$AuthenticationStatusChangedCopyWithImpl;
@useResult
$Res call({
 User? user
});




}
/// @nodoc
class _$AuthenticationStatusChangedCopyWithImpl<$Res>
    implements $AuthenticationStatusChangedCopyWith<$Res> {
  _$AuthenticationStatusChangedCopyWithImpl(this._self, this._then);

  final AuthenticationStatusChanged _self;
  final $Res Function(AuthenticationStatusChanged) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(AuthenticationStatusChanged(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}


}

/// @nodoc

@internal
class AuthenticationPasswordRecoveryDetected implements AuthenticationEvent {
  const AuthenticationPasswordRecoveryDetected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationPasswordRecoveryDetected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.passwordRecoveryDetected()';
}


}




/// @nodoc

@internal
class AuthenticationEmailConfirmationDetected implements AuthenticationEvent {
  const AuthenticationEmailConfirmationDetected({this.performSignOut = true});
  

@JsonKey() final  bool performSignOut;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationEmailConfirmationDetectedCopyWith<AuthenticationEmailConfirmationDetected> get copyWith => _$AuthenticationEmailConfirmationDetectedCopyWithImpl<AuthenticationEmailConfirmationDetected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEmailConfirmationDetected&&(identical(other.performSignOut, performSignOut) || other.performSignOut == performSignOut));
}


@override
int get hashCode => Object.hash(runtimeType,performSignOut);

@override
String toString() {
  return 'AuthenticationEvent.emailConfirmationDetected(performSignOut: $performSignOut)';
}


}

/// @nodoc
abstract mixin class $AuthenticationEmailConfirmationDetectedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationEmailConfirmationDetectedCopyWith(AuthenticationEmailConfirmationDetected value, $Res Function(AuthenticationEmailConfirmationDetected) _then) = _$AuthenticationEmailConfirmationDetectedCopyWithImpl;
@useResult
$Res call({
 bool performSignOut
});




}
/// @nodoc
class _$AuthenticationEmailConfirmationDetectedCopyWithImpl<$Res>
    implements $AuthenticationEmailConfirmationDetectedCopyWith<$Res> {
  _$AuthenticationEmailConfirmationDetectedCopyWithImpl(this._self, this._then);

  final AuthenticationEmailConfirmationDetected _self;
  final $Res Function(AuthenticationEmailConfirmationDetected) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? performSignOut = null,}) {
  return _then(AuthenticationEmailConfirmationDetected(
performSignOut: null == performSignOut ? _self.performSignOut : performSignOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AuthenticationEmailConfirmationAcknowledged implements AuthenticationEvent {
  const AuthenticationEmailConfirmationAcknowledged();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEmailConfirmationAcknowledged);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.emailConfirmationAcknowledged()';
}


}




// dart format on
