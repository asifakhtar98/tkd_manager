// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bracket_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleEliminationResult _$SingleEliminationResultFromJson(
  Map<String, dynamic> json,
) => SingleEliminationResult(
  BracketGenerationResult.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SingleEliminationResultToJson(
  SingleEliminationResult instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'runtimeType': instance.$type,
};

DoubleEliminationResult _$DoubleEliminationResultFromJson(
  Map<String, dynamic> json,
) => DoubleEliminationResult(
  DoubleEliminationBracketGenerationResult.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$DoubleEliminationResultToJson(
  DoubleEliminationResult instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'runtimeType': instance.$type,
};

BracketActionMatchResult _$BracketActionMatchResultFromJson(
  Map<String, dynamic> json,
) => BracketActionMatchResult(
  BracketMatchAction.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BracketActionMatchResultToJson(
  BracketActionMatchResult instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'runtimeType': instance.$type,
};

BracketActionEditAction _$BracketActionEditActionFromJson(
  Map<String, dynamic> json,
) => BracketActionEditAction(
  BracketEditAction.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BracketActionEditActionToJson(
  BracketActionEditAction instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'runtimeType': instance.$type,
};

_BracketHistoryEntry _$BracketHistoryEntryFromJson(Map<String, dynamic> json) =>
    _BracketHistoryEntry(
      action: BracketAction.fromJson(json['action'] as Map<String, dynamic>),
      resultSnapshot: BracketResult.fromJson(
        json['resultSnapshot'] as Map<String, dynamic>,
      ),
      participantsSnapshot: (json['participantsSnapshot'] as List<dynamic>)
          .map((e) => ParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BracketHistoryEntryToJson(
  _BracketHistoryEntry instance,
) => <String, dynamic>{
  'action': instance.action.toJson(),
  'resultSnapshot': instance.resultSnapshot.toJson(),
  'participantsSnapshot': instance.participantsSnapshot
      .map((e) => e.toJson())
      .toList(),
};
