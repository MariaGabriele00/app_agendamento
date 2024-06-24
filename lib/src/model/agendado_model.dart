class AgendadoModel {
  final int id;
  final String name;
  final String email;
  final List<String> openingDays;
  final List<int> openingHours;

  AgendadoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.openingDays,
    required this.openingHours,
  });

  factory AgendadoModel.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'email': String email,
        'opening_days': final List openingDays,
        'opening_hours': final List openingHours,
      } =>
        AgendadoModel(
          id: id,
          name: name,
          email: email,
          openingDays: openingDays.cast<String>(),
          openingHours: openingHours.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Json'),
    };
  }
}
