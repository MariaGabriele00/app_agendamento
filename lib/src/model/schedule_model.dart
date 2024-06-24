class ScheduleModel {
  final int id;
  final int agendadoId;
  final int userId;
  final String clientName;
  final DateTime date;
  final int hour;

  ScheduleModel({
    required this.id,
    required this.agendadoId,
    required this.userId,
    required this.clientName,
    required this.date,
    required this.hour,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> json) {
    switch (json) {
      case {
          'id': int id,
          'barbershop_id': int agendadoId,
          'user_id': int userId,
          'client_name': String clientName,
          'date': String scheduleDate,
          'time': int hour,
        }:
        return ScheduleModel(
          id: id,
          agendadoId: agendadoId,
          userId: userId,
          clientName: clientName,
          date: DateTime.parse(scheduleDate),
          hour: hour,
        );
      case _:
        throw ArgumentError('Invalid JSON');
    }
  }
}
