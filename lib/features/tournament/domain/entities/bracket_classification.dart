import 'package:freezed_annotation/freezed_annotation.dart';

part 'bracket_classification.freezed.dart';

/// Bracket-level classification labels displayed in the tie sheet header.
///
/// Groups the three classification dimensions that always travel together:
/// age category, gender, and weight division. Using a value object avoids
/// drilling three separate strings through every layer of the stack.
///
/// Construct with `const BracketClassification()` for an empty default.
@freezed
abstract class BracketClassification with _$BracketClassification {
  const factory BracketClassification({
    /// Age category label, e.g. "JUNIOR", "SENIOR", "CADET".
    @Default('') String ageCategoryLabel,

    /// Gender label, e.g. "BOYS", "GIRLS", "MIXED".
    @Default('') String genderLabel,

    /// Weight division label, e.g. "UNDER 59 KG", "OVER 80 KG".
    @Default('') String weightDivisionLabel,
  }) = _BracketClassification;
}
