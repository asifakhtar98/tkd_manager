class ParticipantEntity {
  final String id;
  final String divisionId;
  final String firstName;
  final String lastName;
  final String? schoolOrDojangName;
  final String? beltRank;
  final String? registrationId;
  final int? seedNumber;
  final bool isBye;

  const ParticipantEntity({
    required this.id,
    required this.divisionId,
    required this.firstName,
    required this.lastName,
    this.schoolOrDojangName,
    this.beltRank,
    this.registrationId,
    this.seedNumber,
    this.isBye = false,
  });

  ParticipantEntity copyWith({
    String? id,
    String? divisionId,
    String? firstName,
    String? lastName,
    String? schoolOrDojangName,
    String? beltRank,
    String? registrationId,
    int? seedNumber,
    bool? isBye,
  }) {
    return ParticipantEntity(
      id: id ?? this.id,
      divisionId: divisionId ?? this.divisionId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      schoolOrDojangName: schoolOrDojangName ?? this.schoolOrDojangName,
      beltRank: beltRank ?? this.beltRank,
      registrationId: registrationId ?? this.registrationId,
      seedNumber: seedNumber ?? this.seedNumber,
      isBye: isBye ?? this.isBye,
    );
  }
}

