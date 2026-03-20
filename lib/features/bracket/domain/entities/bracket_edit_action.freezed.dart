// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_edit_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketEditAction {

 String get displayLabel; DateTime get recordedAt;
/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketEditActionCopyWith<BracketEditAction> get copyWith => _$BracketEditActionCopyWithImpl<BracketEditAction>(this as BracketEditAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketEditAction&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,displayLabel,recordedAt);

@override
String toString() {
  return 'BracketEditAction(displayLabel: $displayLabel, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $BracketEditActionCopyWith<$Res>  {
  factory $BracketEditActionCopyWith(BracketEditAction value, $Res Function(BracketEditAction) _then) = _$BracketEditActionCopyWithImpl;
@useResult
$Res call({
 String displayLabel, DateTime recordedAt
});




}
/// @nodoc
class _$BracketEditActionCopyWithImpl<$Res>
    implements $BracketEditActionCopyWith<$Res> {
  _$BracketEditActionCopyWithImpl(this._self, this._then);

  final BracketEditAction _self;
  final $Res Function(BracketEditAction) _then;

/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayLabel = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketEditAction].
extension BracketEditActionPatterns on BracketEditAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BracketEditActionParticipantSlotSwapped value)?  participantSlotSwapped,TResult Function( BracketEditActionParticipantDetailsUpdated value)?  participantDetailsUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped() when participantSlotSwapped != null:
return participantSlotSwapped(_that);case BracketEditActionParticipantDetailsUpdated() when participantDetailsUpdated != null:
return participantDetailsUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BracketEditActionParticipantSlotSwapped value)  participantSlotSwapped,required TResult Function( BracketEditActionParticipantDetailsUpdated value)  participantDetailsUpdated,}){
final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped():
return participantSlotSwapped(_that);case BracketEditActionParticipantDetailsUpdated():
return participantDetailsUpdated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BracketEditActionParticipantSlotSwapped value)?  participantSlotSwapped,TResult? Function( BracketEditActionParticipantDetailsUpdated value)?  participantDetailsUpdated,}){
final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped() when participantSlotSwapped != null:
return participantSlotSwapped(_that);case BracketEditActionParticipantDetailsUpdated() when participantDetailsUpdated != null:
return participantDetailsUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String sourceMatchId,  String sourceSlotPosition,  String targetMatchId,  String targetSlotPosition,  String displayLabel,  DateTime recordedAt)?  participantSlotSwapped,TResult Function( String participantId,  String updatedFullName,  String? updatedRegistrationId,  String displayLabel,  DateTime recordedAt)?  participantDetailsUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped() when participantSlotSwapped != null:
return participantSlotSwapped(_that.sourceMatchId,_that.sourceSlotPosition,_that.targetMatchId,_that.targetSlotPosition,_that.displayLabel,_that.recordedAt);case BracketEditActionParticipantDetailsUpdated() when participantDetailsUpdated != null:
return participantDetailsUpdated(_that.participantId,_that.updatedFullName,_that.updatedRegistrationId,_that.displayLabel,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String sourceMatchId,  String sourceSlotPosition,  String targetMatchId,  String targetSlotPosition,  String displayLabel,  DateTime recordedAt)  participantSlotSwapped,required TResult Function( String participantId,  String updatedFullName,  String? updatedRegistrationId,  String displayLabel,  DateTime recordedAt)  participantDetailsUpdated,}) {final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped():
return participantSlotSwapped(_that.sourceMatchId,_that.sourceSlotPosition,_that.targetMatchId,_that.targetSlotPosition,_that.displayLabel,_that.recordedAt);case BracketEditActionParticipantDetailsUpdated():
return participantDetailsUpdated(_that.participantId,_that.updatedFullName,_that.updatedRegistrationId,_that.displayLabel,_that.recordedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String sourceMatchId,  String sourceSlotPosition,  String targetMatchId,  String targetSlotPosition,  String displayLabel,  DateTime recordedAt)?  participantSlotSwapped,TResult? Function( String participantId,  String updatedFullName,  String? updatedRegistrationId,  String displayLabel,  DateTime recordedAt)?  participantDetailsUpdated,}) {final _that = this;
switch (_that) {
case BracketEditActionParticipantSlotSwapped() when participantSlotSwapped != null:
return participantSlotSwapped(_that.sourceMatchId,_that.sourceSlotPosition,_that.targetMatchId,_that.targetSlotPosition,_that.displayLabel,_that.recordedAt);case BracketEditActionParticipantDetailsUpdated() when participantDetailsUpdated != null:
return participantDetailsUpdated(_that.participantId,_that.updatedFullName,_that.updatedRegistrationId,_that.displayLabel,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class BracketEditActionParticipantSlotSwapped implements BracketEditAction {
  const BracketEditActionParticipantSlotSwapped({required this.sourceMatchId, required this.sourceSlotPosition, required this.targetMatchId, required this.targetSlotPosition, required this.displayLabel, required this.recordedAt});
  

 final  String sourceMatchId;
 final  String sourceSlotPosition;
 final  String targetMatchId;
 final  String targetSlotPosition;
@override final  String displayLabel;
@override final  DateTime recordedAt;

/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketEditActionParticipantSlotSwappedCopyWith<BracketEditActionParticipantSlotSwapped> get copyWith => _$BracketEditActionParticipantSlotSwappedCopyWithImpl<BracketEditActionParticipantSlotSwapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketEditActionParticipantSlotSwapped&&(identical(other.sourceMatchId, sourceMatchId) || other.sourceMatchId == sourceMatchId)&&(identical(other.sourceSlotPosition, sourceSlotPosition) || other.sourceSlotPosition == sourceSlotPosition)&&(identical(other.targetMatchId, targetMatchId) || other.targetMatchId == targetMatchId)&&(identical(other.targetSlotPosition, targetSlotPosition) || other.targetSlotPosition == targetSlotPosition)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sourceMatchId,sourceSlotPosition,targetMatchId,targetSlotPosition,displayLabel,recordedAt);

@override
String toString() {
  return 'BracketEditAction.participantSlotSwapped(sourceMatchId: $sourceMatchId, sourceSlotPosition: $sourceSlotPosition, targetMatchId: $targetMatchId, targetSlotPosition: $targetSlotPosition, displayLabel: $displayLabel, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $BracketEditActionParticipantSlotSwappedCopyWith<$Res> implements $BracketEditActionCopyWith<$Res> {
  factory $BracketEditActionParticipantSlotSwappedCopyWith(BracketEditActionParticipantSlotSwapped value, $Res Function(BracketEditActionParticipantSlotSwapped) _then) = _$BracketEditActionParticipantSlotSwappedCopyWithImpl;
@override @useResult
$Res call({
 String sourceMatchId, String sourceSlotPosition, String targetMatchId, String targetSlotPosition, String displayLabel, DateTime recordedAt
});




}
/// @nodoc
class _$BracketEditActionParticipantSlotSwappedCopyWithImpl<$Res>
    implements $BracketEditActionParticipantSlotSwappedCopyWith<$Res> {
  _$BracketEditActionParticipantSlotSwappedCopyWithImpl(this._self, this._then);

  final BracketEditActionParticipantSlotSwapped _self;
  final $Res Function(BracketEditActionParticipantSlotSwapped) _then;

/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceMatchId = null,Object? sourceSlotPosition = null,Object? targetMatchId = null,Object? targetSlotPosition = null,Object? displayLabel = null,Object? recordedAt = null,}) {
  return _then(BracketEditActionParticipantSlotSwapped(
sourceMatchId: null == sourceMatchId ? _self.sourceMatchId : sourceMatchId // ignore: cast_nullable_to_non_nullable
as String,sourceSlotPosition: null == sourceSlotPosition ? _self.sourceSlotPosition : sourceSlotPosition // ignore: cast_nullable_to_non_nullable
as String,targetMatchId: null == targetMatchId ? _self.targetMatchId : targetMatchId // ignore: cast_nullable_to_non_nullable
as String,targetSlotPosition: null == targetSlotPosition ? _self.targetSlotPosition : targetSlotPosition // ignore: cast_nullable_to_non_nullable
as String,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class BracketEditActionParticipantDetailsUpdated implements BracketEditAction {
  const BracketEditActionParticipantDetailsUpdated({required this.participantId, required this.updatedFullName, this.updatedRegistrationId, required this.displayLabel, required this.recordedAt});
  

 final  String participantId;
 final  String updatedFullName;
 final  String? updatedRegistrationId;
@override final  String displayLabel;
@override final  DateTime recordedAt;

/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketEditActionParticipantDetailsUpdatedCopyWith<BracketEditActionParticipantDetailsUpdated> get copyWith => _$BracketEditActionParticipantDetailsUpdatedCopyWithImpl<BracketEditActionParticipantDetailsUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketEditActionParticipantDetailsUpdated&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.updatedFullName, updatedFullName) || other.updatedFullName == updatedFullName)&&(identical(other.updatedRegistrationId, updatedRegistrationId) || other.updatedRegistrationId == updatedRegistrationId)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,participantId,updatedFullName,updatedRegistrationId,displayLabel,recordedAt);

@override
String toString() {
  return 'BracketEditAction.participantDetailsUpdated(participantId: $participantId, updatedFullName: $updatedFullName, updatedRegistrationId: $updatedRegistrationId, displayLabel: $displayLabel, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $BracketEditActionParticipantDetailsUpdatedCopyWith<$Res> implements $BracketEditActionCopyWith<$Res> {
  factory $BracketEditActionParticipantDetailsUpdatedCopyWith(BracketEditActionParticipantDetailsUpdated value, $Res Function(BracketEditActionParticipantDetailsUpdated) _then) = _$BracketEditActionParticipantDetailsUpdatedCopyWithImpl;
@override @useResult
$Res call({
 String participantId, String updatedFullName, String? updatedRegistrationId, String displayLabel, DateTime recordedAt
});




}
/// @nodoc
class _$BracketEditActionParticipantDetailsUpdatedCopyWithImpl<$Res>
    implements $BracketEditActionParticipantDetailsUpdatedCopyWith<$Res> {
  _$BracketEditActionParticipantDetailsUpdatedCopyWithImpl(this._self, this._then);

  final BracketEditActionParticipantDetailsUpdated _self;
  final $Res Function(BracketEditActionParticipantDetailsUpdated) _then;

/// Create a copy of BracketEditAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? updatedFullName = null,Object? updatedRegistrationId = freezed,Object? displayLabel = null,Object? recordedAt = null,}) {
  return _then(BracketEditActionParticipantDetailsUpdated(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,updatedFullName: null == updatedFullName ? _self.updatedFullName : updatedFullName // ignore: cast_nullable_to_non_nullable
as String,updatedRegistrationId: freezed == updatedRegistrationId ? _self.updatedRegistrationId : updatedRegistrationId // ignore: cast_nullable_to_non_nullable
as String?,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
