// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_bracket_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetupBracketState _$SetupBracketStateFromJson(
  Map<String, dynamic> json,
) => _SetupBracketState(
  tournamentId: json['tournamentId'] as String,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => ParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  selectedBracketFormat:
      $enumDecodeNullable(
        _$BracketFormatEnumMap,
        json['selectedBracketFormat'],
      ) ??
      BracketFormat.singleElimination,
  isDojangSeparationEnabled: json['isDojangSeparationEnabled'] as bool? ?? true,
  isThirdPlaceMatchIncluded:
      json['isThirdPlaceMatchIncluded'] as bool? ?? false,
  bracketAgeCategoryLabel: json['bracketAgeCategoryLabel'] as String? ?? '',
  bracketGenderLabel: json['bracketGenderLabel'] as String? ?? '',
  bracketWeightDivisionLabel:
      json['bracketWeightDivisionLabel'] as String? ?? '',
  isAwaitingBracketGeneration:
      json['isAwaitingBracketGeneration'] as bool? ?? false,
  pendingSnapshotId: json['pendingSnapshotId'] as String?,
);

Map<String, dynamic> _$SetupBracketStateToJson(_SetupBracketState instance) =>
    <String, dynamic>{
      'tournamentId': instance.tournamentId,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'selectedBracketFormat':
          _$BracketFormatEnumMap[instance.selectedBracketFormat]!,
      'isDojangSeparationEnabled': instance.isDojangSeparationEnabled,
      'isThirdPlaceMatchIncluded': instance.isThirdPlaceMatchIncluded,
      'bracketAgeCategoryLabel': instance.bracketAgeCategoryLabel,
      'bracketGenderLabel': instance.bracketGenderLabel,
      'bracketWeightDivisionLabel': instance.bracketWeightDivisionLabel,
      'isAwaitingBracketGeneration': instance.isAwaitingBracketGeneration,
      'pendingSnapshotId': instance.pendingSnapshotId,
    };

const _$BracketFormatEnumMap = {
  BracketFormat.singleElimination: 'singleElimination',
  BracketFormat.doubleElimination: 'doubleElimination',
};
