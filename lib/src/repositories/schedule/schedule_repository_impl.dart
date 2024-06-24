import 'dart:developer';

import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';

import 'package:app_agendamento/src/core/fp/either.dart';

import 'package:app_agendamento/src/core/fp/nil.dart';
import 'package:app_agendamento/src/core/restClient/rest_client.dart';
import 'package:app_agendamento/src/model/schedule_model.dart';
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

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
      ({DateTime date, int userId}) filter) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/schedules', queryParameters: {
        'user_id': filter.userId,
        'date': filter.date.toIso8601String(),
      });
      final schedules = data.map((s) => ScheduleModel.fromMap(s)).toList();
      return Success(schedules);
    } on DioException catch (e, s) {
      log('Erro ao buscar agendamento de uma data', error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao buscar agendamento de uma data'));
    } on ArgumentError {
      return Failure(RepositoryException(message: 'Json ivalid'));
    }
  }
}
