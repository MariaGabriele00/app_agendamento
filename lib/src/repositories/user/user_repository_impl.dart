import 'dart:developer';
import 'dart:io';

import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';
import 'package:app_agendamento/src/core/fp/nil.dart';
import 'package:app_agendamento/src/model/user_model.dart';
import 'package:dio/dio.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/fp/either.dart';
import '../../core/restClient/rest_client.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;
  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<AuthException, String>> login(
    String email,
    String password,
  ) async {
    try {
      final Response(:data) = await restClient.auth.post('/auth', data: {
        'email': email,
        'password': password,
      });
      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('E-mail ou senha inválidos!', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      log('Erro ao realizar o login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao realizar login'));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');
      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      log('Erro ao buscar o usuário logado', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar o usuário logado'));
    } on ArgumentError catch (e, s) {
      log('Invalid Json', error: e, stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({
        String email,
        String name,
        String password,
      }) userData) async {
    try {
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM',
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar usuário admin', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao registrar usuário admin'));
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
    int agendadoId,
  ) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/users', queryParameters: {
        'barbershop_id': agendadoId,
      });
      final employees =
          (data.map((e) => UserModelEmployee.fromMap(e)).toList());
      return Success(employees);
    } on DioException catch (e, s) {
      log('Erro ao buscar os colaboradores', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar os colaboradores'));
    } on ArgumentError catch (e, s) {
      log('Erro ao converter colaboradores (Invalid Json)',
          error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar os colaboradores'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<int> workhours,
        List<String> workdays,
      }) userModel) async {
    try {
      final userModelResult = await me();
      final int userId;

      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
        case Failure(:var exception):
          return Failure(exception);
      }

      await restClient.auth.put('/users/$userId', data: {
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
        message: 'Erro ao inserir administrador como colaborador',
      ));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int agendadoId,
        String email,
        String name,
        String password,
        List<int> workhours,
        List<String> workdays,
      }) userModel) async {
    try {
      await restClient.auth.post('/users/', data: {
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'barbershop_id': userModel.agendadoId,
        'profile': 'EMPLOYEE',
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
        message: 'Erro ao inserir administrador como colaborador',
      ));
    }
  }
}
