import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:app_agendamento/src/model/agendado_model.dart';
import 'package:app_agendamento/src/model/user_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/either.dart';
import 'home_adm_state.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final AgendadoModel(id: agendadosId) =
        await ref.read(getMyAgendadoProvider.future);

    final me = await ref.watch(getMeProvider.future);

    final employeesResult = await repository.getEmployees(agendadosId);

    switch (employeesResult) {
      case Success(value: var employeesData):
        final employees = <UserModel>[];

        if (me case UserModelADM(workDays: _?, workHours: _?)) {
          employees.add(me);
        }

        employees.addAll(employeesData);

        return HomeAdmState(
          status: HomeAdmStateStatus.loaded,
          employees: employees,
        );
      case Failure():
        return HomeAdmState(
          status: HomeAdmStateStatus.error,
          employees: [],
        );
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
