import 'dart:developer';

import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';

import 'package:app_agendamento/src/core/fp/either.dart';

import 'package:app_agendamento/src/core/fp/nil.dart';
import 'package:app_agendamento/src/core/restClient/rest_client.dart';
import 'package:dio/dio.dart';

import './schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;

  ScheduleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int agendadoId,
        String clientName,
        DateTime date,
        int time,
        int userId,
      }) scheduleData) async {
    try {
      await restClient.auth.post('/schedules', data: {
        'barbershop_id': scheduleData.agendadoId,
        'user_id': scheduleData.userId,
        'client_name': scheduleData.clientName,
        'date': scheduleData.date.toIso8601String(),
        'time': scheduleData.time,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar agendamento', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao agendar horário'),
      );
    }
  }
}
