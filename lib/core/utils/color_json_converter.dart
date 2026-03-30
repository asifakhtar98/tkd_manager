import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

/// A [JsonConverter] that serialises a [Color] to and from its 32-bit ARGB
/// integer representation so that [Color] values can be stored inside a
/// Supabase JSONB column without needing a custom SQL type.
///
/// Usage — annotate the field in your freezed/json_serializable class:
/// ```dart
/// @ColorJsonConverter()
/// required Color myColor,
/// ```
///
/// Serialisation:  [Color] → `int`  (ARGB, e.g. `0xFF1A2B3C`)
/// Deserialisation: `int`  → [Color]
class ColorJsonConverter implements JsonConverter<Color, int> {
  const ColorJsonConverter();

  @override
  Color fromJson(int colorAsArgbInteger) => Color(colorAsArgbInteger);

  @override
  int toJson(Color color) => color.toARGB32();
}
