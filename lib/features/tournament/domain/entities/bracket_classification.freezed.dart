// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_classification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BracketClassification {

/// Age category label, e.g. "JUNIOR", "SENIOR", "CADET".
 String get ageCategoryLabel;/// Gender label, e.g. "BOYS", "GIRLS", "MIXED".
 String get genderLabel;/// Weight division label, e.g. "UNDER 59 KG", "OVER 80 KG".
 String get weightDivisionLabel;
/// Create a copy of BracketClassification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BracketClassificationCopyWith<BracketClassification> get copyWith => _$BracketClassificationCopyWithImpl<BracketClassification>(this as BracketClassification, _$identity);

  /// Serializes this BracketClassification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BracketClassification&&(identical(other.ageCategoryLabel, ageCategoryLabel) || other.ageCategoryLabel == ageCategoryLabel)&&(identical(other.genderLabel, genderLabel) || other.genderLabel == genderLabel)&&(identical(other.weightDivisionLabel, weightDivisionLabel) || other.weightDivisionLabel == weightDivisionLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ageCategoryLabel,genderLabel,weightDivisionLabel);

@override
String toString() {
  return 'BracketClassification(ageCategoryLabel: $ageCategoryLabel, genderLabel: $genderLabel, weightDivisionLabel: $weightDivisionLabel)';
}


}

/// @nodoc
abstract mixin class $BracketClassificationCopyWith<$Res>  {
  factory $BracketClassificationCopyWith(BracketClassification value, $Res Function(BracketClassification) _then) = _$BracketClassificationCopyWithImpl;
@useResult
$Res call({
 String ageCategoryLabel, String genderLabel, String weightDivisionLabel
});




}
/// @nodoc
class _$BracketClassificationCopyWithImpl<$Res>
    implements $BracketClassificationCopyWith<$Res> {
  _$BracketClassificationCopyWithImpl(this._self, this._then);

  final BracketClassification _self;
  final $Res Function(BracketClassification) _then;

/// Create a copy of BracketClassification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ageCategoryLabel = null,Object? genderLabel = null,Object? weightDivisionLabel = null,}) {
  return _then(_self.copyWith(
ageCategoryLabel: null == ageCategoryLabel ? _self.ageCategoryLabel : ageCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,genderLabel: null == genderLabel ? _self.genderLabel : genderLabel // ignore: cast_nullable_to_non_nullable
as String,weightDivisionLabel: null == weightDivisionLabel ? _self.weightDivisionLabel : weightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BracketClassification].
extension BracketClassificationPatterns on BracketClassification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BracketClassification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BracketClassification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BracketClassification value)  $default,){
final _that = this;
switch (_that) {
case _BracketClassification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BracketClassification value)?  $default,){
final _that = this;
switch (_that) {
case _BracketClassification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BracketClassification() when $default != null:
return $default(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)  $default,) {final _that = this;
switch (_that) {
case _BracketClassification():
return $default(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ageCategoryLabel,  String genderLabel,  String weightDivisionLabel)?  $default,) {final _that = this;
switch (_that) {
case _BracketClassification() when $default != null:
return $default(_that.ageCategoryLabel,_that.genderLabel,_that.weightDivisionLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BracketClassification implements BracketClassification {
  const _BracketClassification({this.ageCategoryLabel = '', this.genderLabel = '', this.weightDivisionLabel = ''});
  factory _BracketClassification.fromJson(Map<String, dynamic> json) => _$BracketClassificationFromJson(json);

/// Age category label, e.g. "JUNIOR", "SENIOR", "CADET".
@override@JsonKey() final  String ageCategoryLabel;
/// Gender label, e.g. "BOYS", "GIRLS", "MIXED".
@override@JsonKey() final  String genderLabel;
/// Weight division label, e.g. "UNDER 59 KG", "OVER 80 KG".
@override@JsonKey() final  String weightDivisionLabel;

/// Create a copy of BracketClassification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BracketClassificationCopyWith<_BracketClassification> get copyWith => __$BracketClassificationCopyWithImpl<_BracketClassification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BracketClassificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BracketClassification&&(identical(other.ageCategoryLabel, ageCategoryLabel) || other.ageCategoryLabel == ageCategoryLabel)&&(identical(other.genderLabel, genderLabel) || other.genderLabel == genderLabel)&&(identical(other.weightDivisionLabel, weightDivisionLabel) || other.weightDivisionLabel == weightDivisionLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ageCategoryLabel,genderLabel,weightDivisionLabel);

@override
String toString() {
  return 'BracketClassification(ageCategoryLabel: $ageCategoryLabel, genderLabel: $genderLabel, weightDivisionLabel: $weightDivisionLabel)';
}


}

/// @nodoc
abstract mixin class _$BracketClassificationCopyWith<$Res> implements $BracketClassificationCopyWith<$Res> {
  factory _$BracketClassificationCopyWith(_BracketClassification value, $Res Function(_BracketClassification) _then) = __$BracketClassificationCopyWithImpl;
@override @useResult
$Res call({
 String ageCategoryLabel, String genderLabel, String weightDivisionLabel
});




}
/// @nodoc
class __$BracketClassificationCopyWithImpl<$Res>
    implements _$BracketClassificationCopyWith<$Res> {
  __$BracketClassificationCopyWithImpl(this._self, this._then);

  final _BracketClassification _self;
  final $Res Function(_BracketClassification) _then;

/// Create a copy of BracketClassification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ageCategoryLabel = null,Object? genderLabel = null,Object? weightDivisionLabel = null,}) {
  return _then(_BracketClassification(
ageCategoryLabel: null == ageCategoryLabel ? _self.ageCategoryLabel : ageCategoryLabel // ignore: cast_nullable_to_non_nullable
as String,genderLabel: null == genderLabel ? _self.genderLabel : genderLabel // ignore: cast_nullable_to_non_nullable
as String,weightDivisionLabel: null == weightDivisionLabel ? _self.weightDivisionLabel : weightDivisionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
