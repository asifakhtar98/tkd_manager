// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_setup_seed_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BracketSetupSeedData {

/// The participant roster from the source bracket, with BYE entries
/// already excluded by the caller.
 List<ParticipantEntity> get participants;/// The elimination format used in the source bracket.
 BracketFormat get selectedBracketFormat;/// Whether dojang/school separation was enabled in the source bracket.
 bool get isDojangSeparationEnabled;/// Whether a 3rd-place match was included in the source bracket.
 bool get isThirdPlaceMatchIncluded;/// Classification: age category label (e.g. "Junior", "Senior").
 String get bracketAgeCategoryLabel;/// Classification: gender label (e.g. "Male", "Female").
 String get bracketGenderLabel;/// Classification: weight division label (e.g. "-58kg").
 String get bracketWeightDivisionLabel;
/// Create a copy of BracketSetupSeedData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketSetupSeedDataCopyWith<BracketSetupSeedData> get copyWith => _$BracketSetupSeedDataCopyWithImpl<BracketSetupSeedData>(this as BracketSetupSeedData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketSetupSeedData&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.selectedBracketFormat, selectedBracketFormat) || other.selectedBracketFormat == selectedBracketFormat)&&(identical(other.isDojangSeparationEnabled, isDojangSeparationEnabled) || other.isDojangSeparationEnabled == isDojangSeparationEnabled)&&(identical(other.isThirdPlaceMatchIncluded, isThirdPlaceMatchIncluded) || other.isThirdPlaceMatchIncluded == isThirdPlaceMatchIncluded)&&(identical(other.bracketAgeCategoryLabel, bracketAgeCategoryLabel) || other.bracketAgeCategoryLabel == bracketAgeCategoryLabel)&&(identical(other.bracketGenderLabel, bracketGenderLabel) || other.bracketGenderLabel == bracketGenderLabel)&&(identical(other.bracketWeightDivisionLabel, bracketWeightDivisionLabel) || other.bracketWeightDivisionLabel == bracketWeightDivisionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(participants),selectedBracketFormat,isDojangSeparationEnabled,isThirdPlaceMatchIncluded,bracketAgeCategoryLabel,bracketGenderLabel,bracketWeightDivisionLabel);

@override
String toString() {
  return 'BracketSetupSeedData(participants: $participants, selectedBracketFormat: $selectedBracketFormat, isDojangSeparationEnabled: $isDojangSeparationEnabled, isThirdPlaceMatchIncluded: $isThirdPlaceMatchIncluded, bracketAgeCategoryLabel: $bracketAgeCategoryLabel, bracketGenderLabel: $bracketGenderLabel, bracketWeightDivisionLabel: $bracketWeightDivisionLabel)';
}


}

/// @nodoc
abstract mixin class $BracketSetupSeedDataCopyWith<$Res>  {
  factory $BracketSetupSeedDataCopyWith(BracketSetupSeedData value, $Res Function(BracketSetupSeedData) _then) = _$BracketSetupSeedDataCopyWithImpl;
@useResult
$Res call({
 List<ParticipantEntity> participants, BracketFormat selectedBracketFormat, bool isDojangSeparationEnabled, bool isThirdPlaceMatchIncluded, String bracketAgeCategoryLabel, String bracketGenderLabel, String bracketWeightDivisionLabel
});




}
/// @nodoc
class _$BracketSetupSeedDataCopyWithImpl<$Res>
    implements $BracketSetupSeedDataCopyWith<$Res> {
  _$BracketSetupSeedDataCopyWithImpl(this._self, this._then);

  final BracketSetupSeedData _self;
  final $Res Function(BracketSetupSeedData) _then;

/// Create a copy of BracketSetupSeedData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participants = null,Object? selectedBracketFormat = null,Object? isDojangSeparationEnabled = null,Object? isThirdPlaceMatchIncluded = null,Object? bracketAgeCategoryLabel = null,Object? bracketGenderLabel = null,Object? bracketWeightDivisionLabel = null,}) {
  return _then(_self.copyWith(
participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,selectedBracketFormat: null == selectedBracketFormat ? _self.selectedBracketFormat : selectedBracketFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,isDojangSeparationEnabled: null == isDojangSeparationEnabled ? _self.isDojangSeparationEnabled : isDojangSeparationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isThirdPlaceMatchIncluded: null == isThirdPlaceMatchIncluded ? _self.isThirdPlaceMatchIncluded : isThirdPlaceMatchIncluded // ignore: cast_nullable_to_non_nullable
as bool,bracketAgeCategoryLabel: null == bracketAgeCategoryLabel ? _self.bracketAgeCategoryLabel : bracketAgeCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,bracketGenderLabel: null == bracketGenderLabel ? _self.bracketGenderLabel : bracketGenderLabel // ignore: cast_nullable_to_non_nullable
as String,bracketWeightDivisionLabel: null == bracketWeightDivisionLabel ? _self.bracketWeightDivisionLabel : bracketWeightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketSetupSeedData].
extension BracketSetupSeedDataPatterns on BracketSetupSeedData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketSetupSeedData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketSetupSeedData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketSetupSeedData value)  $default,){
final _that = this;
switch (_that) {
case _BracketSetupSeedData():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketSetupSeedData value)?  $default,){
final _that = this;
switch (_that) {
case _BracketSetupSeedData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketSetupSeedData() when $default != null:
return $default(_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel)  $default,) {final _that = this;
switch (_that) {
case _BracketSetupSeedData():
return $default(_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ParticipantEntity> participants,  BracketFormat selectedBracketFormat,  bool isDojangSeparationEnabled,  bool isThirdPlaceMatchIncluded,  String bracketAgeCategoryLabel,  String bracketGenderLabel,  String bracketWeightDivisionLabel)?  $default,) {final _that = this;
switch (_that) {
case _BracketSetupSeedData() when $default != null:
return $default(_that.participants,_that.selectedBracketFormat,_that.isDojangSeparationEnabled,_that.isThirdPlaceMatchIncluded,_that.bracketAgeCategoryLabel,_that.bracketGenderLabel,_that.bracketWeightDivisionLabel);case _:
  return null;

}
}

}

/// @nodoc


class _BracketSetupSeedData implements BracketSetupSeedData {
  const _BracketSetupSeedData({required final  List<ParticipantEntity> participants, required this.selectedBracketFormat, required this.isDojangSeparationEnabled, required this.isThirdPlaceMatchIncluded, required this.bracketAgeCategoryLabel, required this.bracketGenderLabel, required this.bracketWeightDivisionLabel}): _participants = participants;
  

/// The participant roster from the source bracket, with BYE entries
/// already excluded by the caller.
 final  List<ParticipantEntity> _participants;
/// The participant roster from the source bracket, with BYE entries
/// already excluded by the caller.
@override List<ParticipantEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

/// The elimination format used in the source bracket.
@override final  BracketFormat selectedBracketFormat;
/// Whether dojang/school separation was enabled in the source bracket.
@override final  bool isDojangSeparationEnabled;
/// Whether a 3rd-place match was included in the source bracket.
@override final  bool isThirdPlaceMatchIncluded;
/// Classification: age category label (e.g. "Junior", "Senior").
@override final  String bracketAgeCategoryLabel;
/// Classification: gender label (e.g. "Male", "Female").
@override final  String bracketGenderLabel;
/// Classification: weight division label (e.g. "-58kg").
@override final  String bracketWeightDivisionLabel;

/// Create a copy of BracketSetupSeedData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketSetupSeedDataCopyWith<_BracketSetupSeedData> get copyWith => __$BracketSetupSeedDataCopyWithImpl<_BracketSetupSeedData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketSetupSeedData&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.selectedBracketFormat, selectedBracketFormat) || other.selectedBracketFormat == selectedBracketFormat)&&(identical(other.isDojangSeparationEnabled, isDojangSeparationEnabled) || other.isDojangSeparationEnabled == isDojangSeparationEnabled)&&(identical(other.isThirdPlaceMatchIncluded, isThirdPlaceMatchIncluded) || other.isThirdPlaceMatchIncluded == isThirdPlaceMatchIncluded)&&(identical(other.bracketAgeCategoryLabel, bracketAgeCategoryLabel) || other.bracketAgeCategoryLabel == bracketAgeCategoryLabel)&&(identical(other.bracketGenderLabel, bracketGenderLabel) || other.bracketGenderLabel == bracketGenderLabel)&&(identical(other.bracketWeightDivisionLabel, bracketWeightDivisionLabel) || other.bracketWeightDivisionLabel == bracketWeightDivisionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_participants),selectedBracketFormat,isDojangSeparationEnabled,isThirdPlaceMatchIncluded,bracketAgeCategoryLabel,bracketGenderLabel,bracketWeightDivisionLabel);

@override
String toString() {
  return 'BracketSetupSeedData(participants: $participants, selectedBracketFormat: $selectedBracketFormat, isDojangSeparationEnabled: $isDojangSeparationEnabled, isThirdPlaceMatchIncluded: $isThirdPlaceMatchIncluded, bracketAgeCategoryLabel: $bracketAgeCategoryLabel, bracketGenderLabel: $bracketGenderLabel, bracketWeightDivisionLabel: $bracketWeightDivisionLabel)';
}


}

/// @nodoc
abstract mixin class _$BracketSetupSeedDataCopyWith<$Res> implements $BracketSetupSeedDataCopyWith<$Res> {
  factory _$BracketSetupSeedDataCopyWith(_BracketSetupSeedData value, $Res Function(_BracketSetupSeedData) _then) = __$BracketSetupSeedDataCopyWithImpl;
@override @useResult
$Res call({
 List<ParticipantEntity> participants, BracketFormat selectedBracketFormat, bool isDojangSeparationEnabled, bool isThirdPlaceMatchIncluded, String bracketAgeCategoryLabel, String bracketGenderLabel, String bracketWeightDivisionLabel
});




}
/// @nodoc
class __$BracketSetupSeedDataCopyWithImpl<$Res>
    implements _$BracketSetupSeedDataCopyWith<$Res> {
  __$BracketSetupSeedDataCopyWithImpl(this._self, this._then);

  final _BracketSetupSeedData _self;
  final $Res Function(_BracketSetupSeedData) _then;

/// Create a copy of BracketSetupSeedData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participants = null,Object? selectedBracketFormat = null,Object? isDojangSeparationEnabled = null,Object? isThirdPlaceMatchIncluded = null,Object? bracketAgeCategoryLabel = null,Object? bracketGenderLabel = null,Object? bracketWeightDivisionLabel = null,}) {
  return _then(_BracketSetupSeedData(
participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantEntity>,selectedBracketFormat: null == selectedBracketFormat ? _self.selectedBracketFormat : selectedBracketFormat // ignore: cast_nullable_to_non_nullable
as BracketFormat,isDojangSeparationEnabled: null == isDojangSeparationEnabled ? _self.isDojangSeparationEnabled : isDojangSeparationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isThirdPlaceMatchIncluded: null == isThirdPlaceMatchIncluded ? _self.isThirdPlaceMatchIncluded : isThirdPlaceMatchIncluded // ignore: cast_nullable_to_non_nullable
as bool,bracketAgeCategoryLabel: null == bracketAgeCategoryLabel ? _self.bracketAgeCategoryLabel : bracketAgeCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,bracketGenderLabel: null == bracketGenderLabel ? _self.bracketGenderLabel : bracketGenderLabel // ignore: cast_nullable_to_non_nullable
as String,bracketWeightDivisionLabel: null == bracketWeightDivisionLabel ? _self.bracketWeightDivisionLabel : bracketWeightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
