import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

part 'tournament_model.freezed.dart';
part 'tournament_model.g.dart';

@freezed
abstract class TournamentModel with _$TournamentModel {
  const TournamentModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory TournamentModel({
    required String id,
    required String userId,
    required String name,
    @Default('') String dateRange,
    @Default('') String venue,
    @Default('') String organizer,
    @Default('https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/India_Taekwondo_logo_5346.png')
    String rightLogoUrl,
    @Default('https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/World_Taekwondo+logo_356345.png')
    String leftLogoUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TournamentModel;

  factory TournamentModel.fromJson(Map<String, dynamic> json) => _$TournamentModelFromJson(json);

  factory TournamentModel.fromEntity(TournamentEntity entity) {
    return TournamentModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      dateRange: entity.dateRange,
      venue: entity.venue,
      organizer: entity.organizer,
      rightLogoUrl: entity.rightLogoUrl,
      leftLogoUrl: entity.leftLogoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

extension TournamentModelToEntity on TournamentModel {
  TournamentEntity toEntity() {
    return TournamentEntity(
      id: id,
      userId: userId,
      name: name,
      dateRange: dateRange,
      venue: venue,
      organizer: organizer,
      rightLogoUrl: rightLogoUrl,
      leftLogoUrl: leftLogoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
