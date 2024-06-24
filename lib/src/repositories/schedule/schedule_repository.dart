import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';

import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int agendadoId,
        int userId,
        String clientName,
        DateTime date,
        int time,
      }) scheduleData);
}
