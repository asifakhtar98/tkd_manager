// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_bracket_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetupBracketEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupBracketEvent()';
}


}

/// @nodoc
class $SetupBracketEventCopyWith<$Res>  {
$SetupBracketEventCopyWith(SetupBracketEvent _, $Res Function(SetupBracketEvent) __);
}


/// Adds pattern-matching-related methods to [SetupBracketEvent].
extension SetupBracketEventPatterns on SetupBracketEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SetupBracketParticipantAdded value)?  participantAdded,TResult Function( SetupBracketParticipantsImportedFromCsv value)?  participantsImportedFromCsv,TResult Function( SetupBracketParticipantRemoved value)?  participantRemoved,TResult Function( SetupBracketParticipantsCleared value)?  participantsCleared,TResult Function( SetupBracketParticipantsReordered value)?  participantsReordered,TResult Function( SetupBracketFormatChanged value)?  bracketFormatChanged,TResult Function( SetupBracketDojangSeparationToggled value)?  dojangSeparationToggled,TResult Function( SetupBracketThirdPlaceMatchToggled value)?  thirdPlaceMatchToggled,TResult Function( SetupBracketClassificationUpdated value)?  classificationUpdated,TResult Function( SetupBracketGenerationDispatched value)?  bracketGenerationDispatched,TResult Function( SetupBracketGenerationSucceeded value)?  bracketGenerationSucceeded,TResult Function( SetupBracketGenerationFailed value)?  bracketGenerationFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SetupBracketParticipantAdded() when participantAdded != null:
return participantAdded(_that);case SetupBracketParticipantsImportedFromCsv() when participantsImportedFromCsv != null:
return participantsImportedFromCsv(_that);case SetupBracketParticipantRemoved() when participantRemoved != null:
return participantRemoved(_that);case SetupBracketParticipantsCleared() when participantsCleared != null:
return participantsCleared(_that);case SetupBracketParticipantsReordered() when participantsReordered != null:
return participantsReordered(_that);case SetupBracketFormatChanged() when bracketFormatChanged != null:
return bracketFormatChanged(_that);case SetupBracketDojangSeparationToggled() when dojangSeparationToggled != null:
return dojangSeparationToggled(_that);case SetupBracketThirdPlaceMatchToggled() when thirdPlaceMatchToggled != null:
return thirdPlaceMatchToggled(_that);case SetupBracketClassificationUpdated() when classificationUpdated != null:
return classificationUpdated(_that);case SetupBracketGenerationDispatched() when bracketGenerationDispatched != null:
return bracketGenerationDispatched(_that);case SetupBracketGenerationSucceeded() when bracketGenerationSucceeded != null:
return bracketGenerationSucceeded(_that);case SetupBracketGenerationFailed() when bracketGenerationFailed != null:
return bracketGenerationFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SetupBracketParticipantAdded value)  participantAdded,required TResult Function( SetupBracketParticipantsImportedFromCsv value)  participantsImportedFromCsv,required TResult Function( SetupBracketParticipantRemoved value)  participantRemoved,required TResult Function( SetupBracketParticipantsCleared value)  participantsCleared,required TResult Function( SetupBracketParticipantsReordered value)  participantsReordered,required TResult Function( SetupBracketFormatChanged value)  bracketFormatChanged,required TResult Function( SetupBracketDojangSeparationToggled value)  dojangSeparationToggled,required TResult Function( SetupBracketThirdPlaceMatchToggled value)  thirdPlaceMatchToggled,required TResult Function( SetupBracketClassificationUpdated value)  classificationUpdated,required TResult Function( SetupBracketGenerationDispatched value)  bracketGenerationDispatched,required TResult Function( SetupBracketGenerationSucceeded value)  bracketGenerationSucceeded,required TResult Function( SetupBracketGenerationFailed value)  bracketGenerationFailed,}){
final _that = this;
switch (_that) {
case SetupBracketParticipantAdded():
return participantAdded(_that);case SetupBracketParticipantsImportedFromCsv():
return participantsImportedFromCsv(_that);case SetupBracketParticipantRemoved():
return participantRemoved(_that);case SetupBracketParticipantsCleared():
return participantsCleared(_that);case SetupBracketParticipantsReordered():
return participantsReordered(_that);case SetupBracketFormatChanged():
return bracketFormatChanged(_that);case SetupBracketDojangSeparationToggled():
return dojangSeparationToggled(_that);case SetupBracketThirdPlaceMatchToggled():
return thirdPlaceMatchToggled(_that);case SetupBracketClassificationUpdated():
return classificationUpdated(_that);case SetupBracketGenerationDispatched():
return bracketGenerationDispatched(_that);case SetupBracketGenerationSucceeded():
return bracketGenerationSucceeded(_that);case SetupBracketGenerationFailed():
return bracketGenerationFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SetupBracketParticipantAdded value)?  participantAdded,TResult? Function( SetupBracketParticipantsImportedFromCsv value)?  participantsImportedFromCsv,TResult? Function( SetupBracketParticipantRemoved value)?  participantRemoved,TResult? Function( SetupBracketParticipantsCleared value)?  participantsCleared,TResult? Function( SetupBracketParticipantsReordered value)?  participantsReordered,TResult? Function( SetupBracketFormatChanged value)?  bracketFormatChanged,TResult? Function( SetupBracketDojangSeparationToggled value)?  dojangSeparationToggled,TResult? Function( SetupBracketThirdPlaceMatchToggled value)?  thirdPlaceMatchToggled,TResult? Function( SetupBracketClassificationUpdated value)?  classificationUpdated,TResult? Function( SetupBracketGenerationDispatched value)?  bracketGenerationDispatched,TResult? Function( SetupBracketGenerationSucceeded value)?  bracketGenerationSucceeded,TResult? Function( SetupBracketGenerationFailed value)?  bracketGenerationFailed,}){
final _that = this;
switch (_that) {
case SetupBracketParticipantAdded() when participantAdded != null:
return participantAdded(_that);case SetupBracketParticipantsImportedFromCsv() when participantsImportedFromCsv != null:
return participantsImportedFromCsv(_that);case SetupBracketParticipantRemoved() when participantRemoved != null:
return participantRemoved(_that);case SetupBracketParticipantsCleared() when participantsCleared != null:
return participantsCleared(_that);case SetupBracketParticipantsReordered() when participantsReordered != null:
return participantsReordered(_that);case SetupBracketFormatChanged() when bracketFormatChanged != null:
return bracketFormatChanged(_that);case SetupBracketDojangSeparationToggled() when dojangSeparationToggled != null:
return dojangSeparationToggled(_that);case SetupBracketThirdPlaceMatchToggled() when thirdPlaceMatchToggled != null:
return thirdPlaceMatchToggled(_that);case SetupBracketClassificationUpdated() when classificationUpdated != null:
return classificationUpdated(_that);case SetupBracketGenerationDispatched() when bracketGenerationDispatched != null:
return bracketGenerationDispatched(_that);case SetupBracketGenerationSucceeded() when bracketGenerationSucceeded != null:
return bracketGenerationSucceeded(_that);case SetupBracketGenerationFailed() when bracketGenerationFailed != null:
return bracketGenerationFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String fullName,  String? registrationId,  String? schoolOrDojangName)?  participantAdded,TResult Function( String csvRawText)?  participantsImportedFromCsv,TResult Function( int rosterIndex)?  participantRemoved,TResult Function()?  participantsCleared,TResult Function( int oldIndex,  int newIndex)?  participantsReordered,TResult Function( BracketFormat newFormat)?  bracketFormatChanged,TResult Function( bool isEnabled)?  dojangSeparationToggled,TResult Function( bool isEnabled)?  thirdPlaceMatchToggled,TResult Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)?  classificationUpdated,TResult Function( String pendingSnapshotId)?  bracketGenerationDispatched,TResult Function()?  bracketGenerationSucceeded,TResult Function()?  bracketGenerationFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SetupBracketParticipantAdded() when participantAdded != null:
return participantAdded(_that.fullName,_that.registrationId,_that.schoolOrDojangName);case SetupBracketParticipantsImportedFromCsv() when participantsImportedFromCsv != null:
return participantsImportedFromCsv(_that.csvRawText);case SetupBracketParticipantRemoved() when participantRemoved != null:
return participantRemoved(_that.rosterIndex);case SetupBracketParticipantsCleared() when participantsCleared != null:
return participantsCleared();case SetupBracketParticipantsReordered() when participantsReordered != null:
return participantsReordered(_that.oldIndex,_that.newIndex);case SetupBracketFormatChanged() when bracketFormatChanged != null:
return bracketFormatChanged(_that.newFormat);case SetupBracketDojangSeparationToggled() when dojangSeparationToggled != null:
return dojangSeparationToggled(_that.isEnabled);case SetupBracketThirdPlaceMatchToggled() when thirdPlaceMatchToggled != null:
return thirdPlaceMatchToggled(_that.isEnabled);case SetupBracketClassificationUpdated() when classificationUpdated != null:
return classificationUpdated(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case SetupBracketGenerationDispatched() when bracketGenerationDispatched != null:
return bracketGenerationDispatched(_that.pendingSnapshotId);case SetupBracketGenerationSucceeded() when bracketGenerationSucceeded != null:
return bracketGenerationSucceeded();case SetupBracketGenerationFailed() when bracketGenerationFailed != null:
return bracketGenerationFailed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String fullName,  String? registrationId,  String? schoolOrDojangName)  participantAdded,required TResult Function( String csvRawText)  participantsImportedFromCsv,required TResult Function( int rosterIndex)  participantRemoved,required TResult Function()  participantsCleared,required TResult Function( int oldIndex,  int newIndex)  participantsReordered,required TResult Function( BracketFormat newFormat)  bracketFormatChanged,required TResult Function( bool isEnabled)  dojangSeparationToggled,required TResult Function( bool isEnabled)  thirdPlaceMatchToggled,required TResult Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)  classificationUpdated,required TResult Function( String pendingSnapshotId)  bracketGenerationDispatched,required TResult Function()  bracketGenerationSucceeded,required TResult Function()  bracketGenerationFailed,}) {final _that = this;
switch (_that) {
case SetupBracketParticipantAdded():
return participantAdded(_that.fullName,_that.registrationId,_that.schoolOrDojangName);case SetupBracketParticipantsImportedFromCsv():
return participantsImportedFromCsv(_that.csvRawText);case SetupBracketParticipantRemoved():
return participantRemoved(_that.rosterIndex);case SetupBracketParticipantsCleared():
return participantsCleared();case SetupBracketParticipantsReordered():
return participantsReordered(_that.oldIndex,_that.newIndex);case SetupBracketFormatChanged():
return bracketFormatChanged(_that.newFormat);case SetupBracketDojangSeparationToggled():
return dojangSeparationToggled(_that.isEnabled);case SetupBracketThirdPlaceMatchToggled():
return thirdPlaceMatchToggled(_that.isEnabled);case SetupBracketClassificationUpdated():
return classificationUpdated(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case SetupBracketGenerationDispatched():
return bracketGenerationDispatched(_that.pendingSnapshotId);case SetupBracketGenerationSucceeded():
return bracketGenerationSucceeded();case SetupBracketGenerationFailed():
return bracketGenerationFailed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String fullName,  String? registrationId,  String? schoolOrDojangName)?  participantAdded,TResult? Function( String csvRawText)?  participantsImportedFromCsv,TResult? Function( int rosterIndex)?  participantRemoved,TResult? Function()?  participantsCleared,TResult? Function( int oldIndex,  int newIndex)?  participantsReordered,TResult? Function( BracketFormat newFormat)?  bracketFormatChanged,TResult? Function( bool isEnabled)?  dojangSeparationToggled,TResult? Function( bool isEnabled)?  thirdPlaceMatchToggled,TResult? Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)?  classificationUpdated,TResult? Function( String pendingSnapshotId)?  bracketGenerationDispatched,TResult? Function()?  bracketGenerationSucceeded,TResult? Function()?  bracketGenerationFailed,}) {final _that = this;
switch (_that) {
case SetupBracketParticipantAdded() when participantAdded != null:
return participantAdded(_that.fullName,_that.registrationId,_that.schoolOrDojangName);case SetupBracketParticipantsImportedFromCsv() when participantsImportedFromCsv != null:
return participantsImportedFromCsv(_that.csvRawText);case SetupBracketParticipantRemoved() when participantRemoved != null:
return participantRemoved(_that.rosterIndex);case SetupBracketParticipantsCleared() when participantsCleared != null:
return participantsCleared();case SetupBracketParticipantsReordered() when participantsReordered != null:
return participantsReordered(_that.oldIndex,_that.newIndex);case SetupBracketFormatChanged() when bracketFormatChanged != null:
return bracketFormatChanged(_that.newFormat);case SetupBracketDojangSeparationToggled() when dojangSeparationToggled != null:
return dojangSeparationToggled(_that.isEnabled);case SetupBracketThirdPlaceMatchToggled() when thirdPlaceMatchToggled != null:
return thirdPlaceMatchToggled(_that.isEnabled);case SetupBracketClassificationUpdated() when classificationUpdated != null:
return classificationUpdated(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case SetupBracketGenerationDispatched() when bracketGenerationDispatched != null:
return bracketGenerationDispatched(_that.pendingSnapshotId);case SetupBracketGenerationSucceeded() when bracketGenerationSucceeded != null:
return bracketGenerationSucceeded();case SetupBracketGenerationFailed() when bracketGenerationFailed != null:
return bracketGenerationFailed();case _:
  return null;

}
}

}

/// @nodoc


class SetupBracketParticipantAdded implements SetupBracketEvent {
  const SetupBracketParticipantAdded({required this.fullName, this.registrationId, this.schoolOrDojangName});
  

 final  String fullName;
 final  String? registrationId;
 final  String? schoolOrDojangName;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketParticipantAddedCopyWith<SetupBracketParticipantAdded> get copyWith => _$SetupBracketParticipantAddedCopyWithImpl<SetupBracketParticipantAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketParticipantAdded&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.schoolOrDojangName, schoolOrDojangName) || other.schoolOrDojangName == schoolOrDojangName));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,registrationId,schoolOrDojangName);

@override
String toString() {
  return 'SetupBracketEvent.participantAdded(fullName: $fullName, registrationId: $registrationId, schoolOrDojangName: $schoolOrDojangName)';
}


}

/// @nodoc
abstract mixin class $SetupBracketParticipantAddedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketParticipantAddedCopyWith(SetupBracketParticipantAdded value, $Res Function(SetupBracketParticipantAdded) _then) = _$SetupBracketParticipantAddedCopyWithImpl;
@useResult
$Res call({
 String fullName, String? registrationId, String? schoolOrDojangName
});




}
/// @nodoc
class _$SetupBracketParticipantAddedCopyWithImpl<$Res>
    implements $SetupBracketParticipantAddedCopyWith<$Res> {
  _$SetupBracketParticipantAddedCopyWithImpl(this._self, this._then);

  final SetupBracketParticipantAdded _self;
  final $Res Function(SetupBracketParticipantAdded) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? registrationId = freezed,Object? schoolOrDojangName = freezed,}) {
  return _then(SetupBracketParticipantAdded(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as String?,schoolOrDojangName: freezed == schoolOrDojangName ? _self.schoolOrDojangName : schoolOrDojangName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SetupBracketParticipantsImportedFromCsv implements SetupBracketEvent {
  const SetupBracketParticipantsImportedFromCsv({required this.csvRawText});
  

 final  String csvRawText;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketParticipantsImportedFromCsvCopyWith<SetupBracketParticipantsImportedFromCsv> get copyWith => _$SetupBracketParticipantsImportedFromCsvCopyWithImpl<SetupBracketParticipantsImportedFromCsv>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketParticipantsImportedFromCsv&&(identical(other.csvRawText, csvRawText) || other.csvRawText == csvRawText));
}


@override
int get hashCode => Object.hash(runtimeType,csvRawText);

@override
String toString() {
  return 'SetupBracketEvent.participantsImportedFromCsv(csvRawText: $csvRawText)';
}


}

/// @nodoc
abstract mixin class $SetupBracketParticipantsImportedFromCsvCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketParticipantsImportedFromCsvCopyWith(SetupBracketParticipantsImportedFromCsv value, $Res Function(SetupBracketParticipantsImportedFromCsv) _then) = _$SetupBracketParticipantsImportedFromCsvCopyWithImpl;
@useResult
$Res call({
 String csvRawText
});




}
/// @nodoc
class _$SetupBracketParticipantsImportedFromCsvCopyWithImpl<$Res>
    implements $SetupBracketParticipantsImportedFromCsvCopyWith<$Res> {
  _$SetupBracketParticipantsImportedFromCsvCopyWithImpl(this._self, this._then);

  final SetupBracketParticipantsImportedFromCsv _self;
  final $Res Function(SetupBracketParticipantsImportedFromCsv) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? csvRawText = null,}) {
  return _then(SetupBracketParticipantsImportedFromCsv(
csvRawText: null == csvRawText ? _self.csvRawText : csvRawText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetupBracketParticipantRemoved implements SetupBracketEvent {
  const SetupBracketParticipantRemoved({required this.rosterIndex});
  

 final  int rosterIndex;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketParticipantRemovedCopyWith<SetupBracketParticipantRemoved> get copyWith => _$SetupBracketParticipantRemovedCopyWithImpl<SetupBracketParticipantRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketParticipantRemoved&&(identical(other.rosterIndex, rosterIndex) || other.rosterIndex == rosterIndex));
}


@override
int get hashCode => Object.hash(runtimeType,rosterIndex);

@override
String toString() {
  return 'SetupBracketEvent.participantRemoved(rosterIndex: $rosterIndex)';
}


}

/// @nodoc
abstract mixin class $SetupBracketParticipantRemovedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketParticipantRemovedCopyWith(SetupBracketParticipantRemoved value, $Res Function(SetupBracketParticipantRemoved) _then) = _$SetupBracketParticipantRemovedCopyWithImpl;
@useResult
$Res call({
 int rosterIndex
});




}
/// @nodoc
class _$SetupBracketParticipantRemovedCopyWithImpl<$Res>
    implements $SetupBracketParticipantRemovedCopyWith<$Res> {
  _$SetupBracketParticipantRemovedCopyWithImpl(this._self, this._then);

  final SetupBracketParticipantRemoved _self;
  final $Res Function(SetupBracketParticipantRemoved) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rosterIndex = null,}) {
  return _then(SetupBracketParticipantRemoved(
rosterIndex: null == rosterIndex ? _self.rosterIndex : rosterIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SetupBracketParticipantsCleared implements SetupBracketEvent {
  const SetupBracketParticipantsCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketParticipantsCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupBracketEvent.participantsCleared()';
}


}




/// @nodoc


class SetupBracketParticipantsReordered implements SetupBracketEvent {
  const SetupBracketParticipantsReordered({required this.oldIndex, required this.newIndex});
  

 final  int oldIndex;
 final  int newIndex;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketParticipantsReorderedCopyWith<SetupBracketParticipantsReordered> get copyWith => _$SetupBracketParticipantsReorderedCopyWithImpl<SetupBracketParticipantsReordered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketParticipantsReordered&&(identical(other.oldIndex, oldIndex) || other.oldIndex == oldIndex)&&(identical(other.newIndex, newIndex) || other.newIndex == newIndex));
}


@override
int get hashCode => Object.hash(runtimeType,oldIndex,newIndex);

@override
String toString() {
  return 'SetupBracketEvent.participantsReordered(oldIndex: $oldIndex, newIndex: $newIndex)';
}


}

/// @nodoc
abstract mixin class $SetupBracketParticipantsReorderedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketParticipantsReorderedCopyWith(SetupBracketParticipantsReordered value, $Res Function(SetupBracketParticipantsReordered) _then) = _$SetupBracketParticipantsReorderedCopyWithImpl;
@useResult
$Res call({
 int oldIndex, int newIndex
});




}
/// @nodoc
class _$SetupBracketParticipantsReorderedCopyWithImpl<$Res>
    implements $SetupBracketParticipantsReorderedCopyWith<$Res> {
  _$SetupBracketParticipantsReorderedCopyWithImpl(this._self, this._then);

  final SetupBracketParticipantsReordered _self;
  final $Res Function(SetupBracketParticipantsReordered) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? oldIndex = null,Object? newIndex = null,}) {
  return _then(SetupBracketParticipantsReordered(
oldIndex: null == oldIndex ? _self.oldIndex : oldIndex // ignore: cast_nullable_to_non_nullable
as int,newIndex: null == newIndex ? _self.newIndex : newIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SetupBracketFormatChanged implements SetupBracketEvent {
  const SetupBracketFormatChanged({required this.newFormat});
  

 final  BracketFormat newFormat;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketFormatChangedCopyWith<SetupBracketFormatChanged> get copyWith => _$SetupBracketFormatChangedCopyWithImpl<SetupBracketFormatChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketFormatChanged&&(identical(other.newFormat, newFormat) || other.newFormat == newFormat));
}


@override
int get hashCode => Object.hash(runtimeType,newFormat);

@override
String toString() {
  return 'SetupBracketEvent.bracketFormatChanged(newFormat: $newFormat)';
}


}

/// @nodoc
abstract mixin class $SetupBracketFormatChangedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketFormatChangedCopyWith(SetupBracketFormatChanged value, $Res Function(SetupBracketFormatChanged) _then) = _$SetupBracketFormatChangedCopyWithImpl;
@useResult
$Res call({
 BracketFormat newFormat
});




}
/// @nodoc
class _$SetupBracketFormatChangedCopyWithImpl<$Res>
    implements $SetupBracketFormatChangedCopyWith<$Res> {
  _$SetupBracketFormatChangedCopyWithImpl(this._self, this._then);

  final SetupBracketFormatChanged _self;
  final $Res Function(SetupBracketFormatChanged) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newFormat = null,}) {
  return _then(SetupBracketFormatChanged(
newFormat: null == newFormat ? _self.newFormat : newFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,
  ));
}


}

/// @nodoc


class SetupBracketDojangSeparationToggled implements SetupBracketEvent {
  const SetupBracketDojangSeparationToggled({required this.isEnabled});
  

 final  bool isEnabled;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketDojangSeparationToggledCopyWith<SetupBracketDojangSeparationToggled> get copyWith => _$SetupBracketDojangSeparationToggledCopyWithImpl<SetupBracketDojangSeparationToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketDojangSeparationToggled&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled);

@override
String toString() {
  return 'SetupBracketEvent.dojangSeparationToggled(isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $SetupBracketDojangSeparationToggledCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketDojangSeparationToggledCopyWith(SetupBracketDojangSeparationToggled value, $Res Function(SetupBracketDojangSeparationToggled) _then) = _$SetupBracketDojangSeparationToggledCopyWithImpl;
@useResult
$Res call({
 bool isEnabled
});




}
/// @nodoc
class _$SetupBracketDojangSeparationToggledCopyWithImpl<$Res>
    implements $SetupBracketDojangSeparationToggledCopyWith<$Res> {
  _$SetupBracketDojangSeparationToggledCopyWithImpl(this._self, this._then);

  final SetupBracketDojangSeparationToggled _self;
  final $Res Function(SetupBracketDojangSeparationToggled) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isEnabled = null,}) {
  return _then(SetupBracketDojangSeparationToggled(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SetupBracketThirdPlaceMatchToggled implements SetupBracketEvent {
  const SetupBracketThirdPlaceMatchToggled({required this.isEnabled});
  

 final  bool isEnabled;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketThirdPlaceMatchToggledCopyWith<SetupBracketThirdPlaceMatchToggled> get copyWith => _$SetupBracketThirdPlaceMatchToggledCopyWithImpl<SetupBracketThirdPlaceMatchToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketThirdPlaceMatchToggled&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled);

@override
String toString() {
  return 'SetupBracketEvent.thirdPlaceMatchToggled(isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $SetupBracketThirdPlaceMatchToggledCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketThirdPlaceMatchToggledCopyWith(SetupBracketThirdPlaceMatchToggled value, $Res Function(SetupBracketThirdPlaceMatchToggled) _then) = _$SetupBracketThirdPlaceMatchToggledCopyWithImpl;
@useResult
$Res call({
 bool isEnabled
});




}
/// @nodoc
class _$SetupBracketThirdPlaceMatchToggledCopyWithImpl<$Res>
    implements $SetupBracketThirdPlaceMatchToggledCopyWith<$Res> {
  _$SetupBracketThirdPlaceMatchToggledCopyWithImpl(this._self, this._then);

  final SetupBracketThirdPlaceMatchToggled _self;
  final $Res Function(SetupBracketThirdPlaceMatchToggled) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isEnabled = null,}) {
  return _then(SetupBracketThirdPlaceMatchToggled(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SetupBracketClassificationUpdated implements SetupBracketEvent {
  const SetupBracketClassificationUpdated({required this.ageCategoryLabel, required this.genderLabel, required this.weightDivisionLabel});
  

 final  String ageCategoryLabel;
 final  String genderLabel;
 final  String weightDivisionLabel;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketClassificationUpdatedCopyWith<SetupBracketClassificationUpdated> get copyWith => _$SetupBracketClassificationUpdatedCopyWithImpl<SetupBracketClassificationUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketClassificationUpdated&&(identical(other.ageCategoryLabel, ageCategoryLabel) || other.ageCategoryLabel == ageCategoryLabel)&&(identical(other.genderLabel, genderLabel) || other.genderLabel == genderLabel)&&(identical(other.weightDivisionLabel, weightDivisionLabel) || other.weightDivisionLabel == weightDivisionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,ageCategoryLabel,genderLabel,weightDivisionLabel);

@override
String toString() {
  return 'SetupBracketEvent.classificationUpdated(ageCategoryLabel: $ageCategoryLabel, genderLabel: $genderLabel, weightDivisionLabel: $weightDivisionLabel)';
}


}

/// @nodoc
abstract mixin class $SetupBracketClassificationUpdatedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketClassificationUpdatedCopyWith(SetupBracketClassificationUpdated value, $Res Function(SetupBracketClassificationUpdated) _then) = _$SetupBracketClassificationUpdatedCopyWithImpl;
@useResult
$Res call({
 String ageCategoryLabel, String genderLabel, String weightDivisionLabel
});




}
/// @nodoc
class _$SetupBracketClassificationUpdatedCopyWithImpl<$Res>
    implements $SetupBracketClassificationUpdatedCopyWith<$Res> {
  _$SetupBracketClassificationUpdatedCopyWithImpl(this._self, this._then);

  final SetupBracketClassificationUpdated _self;
  final $Res Function(SetupBracketClassificationUpdated) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ageCategoryLabel = null,Object? genderLabel = null,Object? weightDivisionLabel = null,}) {
  return _then(SetupBracketClassificationUpdated(
ageCategoryLabel: null == ageCategoryLabel ? _self.ageCategoryLabel : ageCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,genderLabel: null == genderLabel ? _self.genderLabel : genderLabel // ignore: cast_nullable_to_non_nullable
as String,weightDivisionLabel: null == weightDivisionLabel ? _self.weightDivisionLabel : weightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetupBracketGenerationDispatched implements SetupBracketEvent {
  const SetupBracketGenerationDispatched({required this.pendingSnapshotId});
  

 final  String pendingSnapshotId;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupBracketGenerationDispatchedCopyWith<SetupBracketGenerationDispatched> get copyWith => _$SetupBracketGenerationDispatchedCopyWithImpl<SetupBracketGenerationDispatched>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketGenerationDispatched&&(identical(other.pendingSnapshotId, pendingSnapshotId) || other.pendingSnapshotId == pendingSnapshotId));
}


@override
int get hashCode => Object.hash(runtimeType,pendingSnapshotId);

@override
String toString() {
  return 'SetupBracketEvent.bracketGenerationDispatched(pendingSnapshotId: $pendingSnapshotId)';
}


}

/// @nodoc
abstract mixin class $SetupBracketGenerationDispatchedCopyWith<$Res> implements $SetupBracketEventCopyWith<$Res> {
  factory $SetupBracketGenerationDispatchedCopyWith(SetupBracketGenerationDispatched value, $Res Function(SetupBracketGenerationDispatched) _then) = _$SetupBracketGenerationDispatchedCopyWithImpl;
@useResult
$Res call({
 String pendingSnapshotId
});




}
/// @nodoc
class _$SetupBracketGenerationDispatchedCopyWithImpl<$Res>
    implements $SetupBracketGenerationDispatchedCopyWith<$Res> {
  _$SetupBracketGenerationDispatchedCopyWithImpl(this._self, this._then);

  final SetupBracketGenerationDispatched _self;
  final $Res Function(SetupBracketGenerationDispatched) _then;

/// Create a copy of SetupBracketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pendingSnapshotId = null,}) {
  return _then(SetupBracketGenerationDispatched(
pendingSnapshotId: null == pendingSnapshotId ? _self.pendingSnapshotId : pendingSnapshotId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetupBracketGenerationSucceeded implements SetupBracketEvent {
  const SetupBracketGenerationSucceeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketGenerationSucceeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupBracketEvent.bracketGenerationSucceeded()';
}


}




/// @nodoc


class SetupBracketGenerationFailed implements SetupBracketEvent {
  const SetupBracketGenerationFailed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupBracketGenerationFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupBracketEvent.bracketGenerationFailed()';
}


}




// dart format on
