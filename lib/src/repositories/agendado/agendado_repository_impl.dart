import 'dart:developer';

import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';
import 'package:app_agendamento/src/core/fp/either.dart';
import 'package:app_agendamento/src/core/fp/nil.dart';
import 'package:app_agendamento/src/model/agendado_model.dart';
import 'package:app_agendamento/src/model/user_model.dart';
import 'package:dio/dio.dart';

import '../../core/restClient/rest_client.dart';
import './agendado_respository.dart';

class AgendadoRespositoryImpl implements AgendadoRespository {
  final RestClient restClient;
  AgendadoRespositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, AgendadoModel>> getMyAgendado(
      UserModel userModel) async {
    switch (userModel) {
      case UserModelADM():
        final Response(data: List(first: data)) = await restClient.auth.get(
          '/barbershop',
          queryParameters: {
            'user_id': '#userAuthRef',
          },
        );
        return Success(AgendadoModel.fromMap(data));

      case UserModelEmployee():
        final Response(:data) =
            await restClient.auth.get('/barbershop/${userModel.agendadoId}');
        return Success(AgendadoModel.fromMap(data));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String email,
        String name,
        List<String> openingDays,
        List<int> openingHours,
      }) data) async {
    try {
      await restClient.auth.post(
        '/barbershop',
        data: {
          'user_id': '#userAuthRef',
          'name': data.name,
          'email': data.email,
          'opening_days': data.openingDays,
          'opening_hours': data.openingHours,
        },
      );
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar agendado', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar agendado'),
      );
    }
  }
}
