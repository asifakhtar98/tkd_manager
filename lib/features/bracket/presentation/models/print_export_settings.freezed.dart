// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'print_export_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrintExportSettings {

 PaperSize get paperSize; PageOrientation get orientation; PrintFitMode get fitMode;/// Scale applied to the bracket when tiling ([minScaleFactor]–[maxScaleFactor]).
/// 1.0 = 1 logical pixel → 1 PDF point.
/// Only used in [PrintFitMode.tileAcrossPages].
 double get scaleFactor;/// Overlap between adjacent tiles in millimeters (0–30).
/// Converted to PDF points internally (1 mm ≈ 2.835 pt).
 double get tileOverlapMillimeters;/// Margin around each page in PDF points.
 double get marginPoints;/// The rasterisation quality / max GPU texture dimension.
 PrintResolutionQuality get resolutionQuality;/// Whether to show assembly aid hints (registration marks and edge
/// neighbor labels) on each tile page. Only used in tile mode.
 bool get showTileAssemblyHints;
/// Create a copy of PrintExportSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrintExportSettingsCopyWith<PrintExportSettings> get copyWith => _$PrintExportSettingsCopyWithImpl<PrintExportSettings>(this as PrintExportSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrintExportSettings&&(identical(other.paperSize, paperSize) || other.paperSize == paperSize)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.fitMode, fitMode) || other.fitMode == fitMode)&&(identical(other.scaleFactor, scaleFactor) || other.scaleFactor == scaleFactor)&&(identical(other.tileOverlapMillimeters, tileOverlapMillimeters) || other.tileOverlapMillimeters == tileOverlapMillimeters)&&(identical(other.marginPoints, marginPoints) || other.marginPoints == marginPoints)&&(identical(other.resolutionQuality, resolutionQuality) || other.resolutionQuality == resolutionQuality)&&(identical(other.showTileAssemblyHints, showTileAssemblyHints) || other.showTileAssemblyHints == showTileAssemblyHints));
}


@override
int get hashCode => Object.hash(runtimeType,paperSize,orientation,fitMode,scaleFactor,tileOverlapMillimeters,marginPoints,resolutionQuality,showTileAssemblyHints);

@override
String toString() {
  return 'PrintExportSettings(paperSize: $paperSize, orientation: $orientation, fitMode: $fitMode, scaleFactor: $scaleFactor, tileOverlapMillimeters: $tileOverlapMillimeters, marginPoints: $marginPoints, resolutionQuality: $resolutionQuality, showTileAssemblyHints: $showTileAssemblyHints)';
}


}

/// @nodoc
abstract mixin class $PrintExportSettingsCopyWith<$Res>  {
  factory $PrintExportSettingsCopyWith(PrintExportSettings value, $Res Function(PrintExportSettings) _then) = _$PrintExportSettingsCopyWithImpl;
@useResult
$Res call({
 PaperSize paperSize, PageOrientation orientation, PrintFitMode fitMode, double scaleFactor, double tileOverlapMillimeters, double marginPoints, PrintResolutionQuality resolutionQuality, bool showTileAssemblyHints
});




}
/// @nodoc
class _$PrintExportSettingsCopyWithImpl<$Res>
    implements $PrintExportSettingsCopyWith<$Res> {
  _$PrintExportSettingsCopyWithImpl(this._self, this._then);

  final PrintExportSettings _self;
  final $Res Function(PrintExportSettings) _then;

/// Create a copy of PrintExportSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paperSize = null,Object? orientation = null,Object? fitMode = null,Object? scaleFactor = null,Object? tileOverlapMillimeters = null,Object? marginPoints = null,Object? resolutionQuality = null,Object? showTileAssemblyHints = null,}) {
  return _then(_self.copyWith(
paperSize: null == paperSize ? _self.paperSize : paperSize // ignore: cast_nullable_to_non_nullable
as PaperSize,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as PageOrientation,fitMode: null == fitMode ? _self.fitMode : fitMode // ignore: cast_nullable_to_non_nullable
as PrintFitMode,scaleFactor: null == scaleFactor ? _self.scaleFactor : scaleFactor // ignore: cast_nullable_to_non_nullable
as double,tileOverlapMillimeters: null == tileOverlapMillimeters ? _self.tileOverlapMillimeters : tileOverlapMillimeters // ignore: cast_nullable_to_non_nullable
as double,marginPoints: null == marginPoints ? _self.marginPoints : marginPoints // ignore: cast_nullable_to_non_nullable
as double,resolutionQuality: null == resolutionQuality ? _self.resolutionQuality : resolutionQuality // ignore: cast_nullable_to_non_nullable
as PrintResolutionQuality,showTileAssemblyHints: null == showTileAssemblyHints ? _self.showTileAssemblyHints : showTileAssemblyHints // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrintExportSettings].
extension PrintExportSettingsPatterns on PrintExportSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrintExportSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrintExportSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrintExportSettings value)  $default,){
final _that = this;
switch (_that) {
case _PrintExportSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrintExportSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PrintExportSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaperSize paperSize,  PageOrientation orientation,  PrintFitMode fitMode,  double scaleFactor,  double tileOverlapMillimeters,  double marginPoints,  PrintResolutionQuality resolutionQuality,  bool showTileAssemblyHints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrintExportSettings() when $default != null:
return $default(_that.paperSize,_that.orientation,_that.fitMode,_that.scaleFactor,_that.tileOverlapMillimeters,_that.marginPoints,_that.resolutionQuality,_that.showTileAssemblyHints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaperSize paperSize,  PageOrientation orientation,  PrintFitMode fitMode,  double scaleFactor,  double tileOverlapMillimeters,  double marginPoints,  PrintResolutionQuality resolutionQuality,  bool showTileAssemblyHints)  $default,) {final _that = this;
switch (_that) {
case _PrintExportSettings():
return $default(_that.paperSize,_that.orientation,_that.fitMode,_that.scaleFactor,_that.tileOverlapMillimeters,_that.marginPoints,_that.resolutionQuality,_that.showTileAssemblyHints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaperSize paperSize,  PageOrientation orientation,  PrintFitMode fitMode,  double scaleFactor,  double tileOverlapMillimeters,  double marginPoints,  PrintResolutionQuality resolutionQuality,  bool showTileAssemblyHints)?  $default,) {final _that = this;
switch (_that) {
case _PrintExportSettings() when $default != null:
return $default(_that.paperSize,_that.orientation,_that.fitMode,_that.scaleFactor,_that.tileOverlapMillimeters,_that.marginPoints,_that.resolutionQuality,_that.showTileAssemblyHints);case _:
  return null;

}
}

}

/// @nodoc


class _PrintExportSettings extends PrintExportSettings {
  const _PrintExportSettings({this.paperSize = PaperSize.a4, this.orientation = PageOrientation.landscape, this.fitMode = PrintFitMode.fitToPage, this.scaleFactor = 1.0, this.tileOverlapMillimeters = 10.0, this.marginPoints = 24.0, this.resolutionQuality = PrintResolutionQuality.standard, this.showTileAssemblyHints = true}): super._();
  

@override@JsonKey() final  PaperSize paperSize;
@override@JsonKey() final  PageOrientation orientation;
@override@JsonKey() final  PrintFitMode fitMode;
/// Scale applied to the bracket when tiling ([minScaleFactor]–[maxScaleFactor]).
/// 1.0 = 1 logical pixel → 1 PDF point.
/// Only used in [PrintFitMode.tileAcrossPages].
@override@JsonKey() final  double scaleFactor;
/// Overlap between adjacent tiles in millimeters (0–30).
/// Converted to PDF points internally (1 mm ≈ 2.835 pt).
@override@JsonKey() final  double tileOverlapMillimeters;
/// Margin around each page in PDF points.
@override@JsonKey() final  double marginPoints;
/// The rasterisation quality / max GPU texture dimension.
@override@JsonKey() final  PrintResolutionQuality resolutionQuality;
/// Whether to show assembly aid hints (registration marks and edge
/// neighbor labels) on each tile page. Only used in tile mode.
@override@JsonKey() final  bool showTileAssemblyHints;

/// Create a copy of PrintExportSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrintExportSettingsCopyWith<_PrintExportSettings> get copyWith => __$PrintExportSettingsCopyWithImpl<_PrintExportSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrintExportSettings&&(identical(other.paperSize, paperSize) || other.paperSize == paperSize)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.fitMode, fitMode) || other.fitMode == fitMode)&&(identical(other.scaleFactor, scaleFactor) || other.scaleFactor == scaleFactor)&&(identical(other.tileOverlapMillimeters, tileOverlapMillimeters) || other.tileOverlapMillimeters == tileOverlapMillimeters)&&(identical(other.marginPoints, marginPoints) || other.marginPoints == marginPoints)&&(identical(other.resolutionQuality, resolutionQuality) || other.resolutionQuality == resolutionQuality)&&(identical(other.showTileAssemblyHints, showTileAssemblyHints) || other.showTileAssemblyHints == showTileAssemblyHints));
}


@override
int get hashCode => Object.hash(runtimeType,paperSize,orientation,fitMode,scaleFactor,tileOverlapMillimeters,marginPoints,resolutionQuality,showTileAssemblyHints);

@override
String toString() {
  return 'PrintExportSettings(paperSize: $paperSize, orientation: $orientation, fitMode: $fitMode, scaleFactor: $scaleFactor, tileOverlapMillimeters: $tileOverlapMillimeters, marginPoints: $marginPoints, resolutionQuality: $resolutionQuality, showTileAssemblyHints: $showTileAssemblyHints)';
}


}

/// @nodoc
abstract mixin class _$PrintExportSettingsCopyWith<$Res> implements $PrintExportSettingsCopyWith<$Res> {
  factory _$PrintExportSettingsCopyWith(_PrintExportSettings value, $Res Function(_PrintExportSettings) _then) = __$PrintExportSettingsCopyWithImpl;
@override @useResult
$Res call({
 PaperSize paperSize, PageOrientation orientation, PrintFitMode fitMode, double scaleFactor, double tileOverlapMillimeters, double marginPoints, PrintResolutionQuality resolutionQuality, bool showTileAssemblyHints
});




}
/// @nodoc
class __$PrintExportSettingsCopyWithImpl<$Res>
    implements _$PrintExportSettingsCopyWith<$Res> {
  __$PrintExportSettingsCopyWithImpl(this._self, this._then);

  final _PrintExportSettings _self;
  final $Res Function(_PrintExportSettings) _then;

/// Create a copy of PrintExportSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paperSize = null,Object? orientation = null,Object? fitMode = null,Object? scaleFactor = null,Object? tileOverlapMillimeters = null,Object? marginPoints = null,Object? resolutionQuality = null,Object? showTileAssemblyHints = null,}) {
  return _then(_PrintExportSettings(
paperSize: null == paperSize ? _self.paperSize : paperSize // ignore: cast_nullable_to_non_nullable
as PaperSize,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as PageOrientation,fitMode: null == fitMode ? _self.fitMode : fitMode // ignore: cast_nullable_to_non_nullable
as PrintFitMode,scaleFactor: null == scaleFactor ? _self.scaleFactor : scaleFactor // ignore: cast_nullable_to_non_nullable
as double,tileOverlapMillimeters: null == tileOverlapMillimeters ? _self.tileOverlapMillimeters : tileOverlapMillimeters // ignore: cast_nullable_to_non_nullable
as double,marginPoints: null == marginPoints ? _self.marginPoints : marginPoints // ignore: cast_nullable_to_non_nullable
as double,resolutionQuality: null == resolutionQuality ? _self.resolutionQuality : resolutionQuality // ignore: cast_nullable_to_non_nullable
as PrintResolutionQuality,showTileAssemblyHints: null == showTileAssemblyHints ? _self.showTileAssemblyHints : showTileAssemblyHints // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
