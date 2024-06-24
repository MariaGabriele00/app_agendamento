import 'package:app_agendamento/src/core/fp/either.dart';
import 'package:app_agendamento/src/model/agendado_model.dart';
import 'package:app_agendamento/src/repositories/schedule/schedule_repository.dart';
import 'package:app_agendamento/src/repositories/user/user_repository.dart';
import 'package:app_agendamento/src/repositories/user/user_repository_impl.dart';
import 'package:app_agendamento/src/services/user_login/user_login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../repositories/agendado/agendado_repository_impl.dart';
import '../../repositories/agendado/agendado_respository.dart';
import '../../repositories/schedule/schedule_repository_impl.dart';
import '../../services/user_login/user_login_service_impl.dart';
import '../restClient/rest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/agendado_nav_global_key.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
RestClient restClient(RestClientRef ref) => RestClient();

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(restClient: ref.read(restClientProvider));

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(userRepository: ref.read(userRepositoryProvider));

@Riverpod(keepAlive: true)
Future<UserModel> getMe(GetMeRef ref) async {
  final result = await ref.watch(userRepositoryProvider).me();

  return switch (result) {
    Success(value: final userModel) => userModel,
    Failure(:final exception) => throw exception,
  };
}

@Riverpod(keepAlive: true)
AgendadoRespository agendadoRespository(AgendadoRespositoryRef ref) =>
    AgendadoRespositoryImpl(restClient: ref.watch(restClientProvider));

@Riverpod(keepAlive: true)
Future<AgendadoModel> getMyAgendado(GetMyAgendadoRef ref) async {
  final userModel = await ref.watch(getMeProvider.future);
  final agendadoRespository = ref.watch(agendadoRespositoryProvider);
  final result = await agendadoRespository.getMyAgendado(userModel);
  return switch (result) {
    Success(value: final agendado) => agendado,
    Failure(:final exception) => throw exception,
  };
}

@riverpod
Future<void> logout(LogoutRef ref) async {
  final sp = await SharedPreferences.getInstance();
  sp.clear();

  ref.invalidate(getMeProvider);
  ref.invalidate(getMyAgendadoProvider);
  Navigator.of(AgendadoNavGlobalKey.instance.navKey.currentContext!)
      .pushNamedAndRemoveUntil('/auth/login', (route) => false);
}

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) =>
    ScheduleRepositoryImpl(restClient: ref.read(restClientProvider));
