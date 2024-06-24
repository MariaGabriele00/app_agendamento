import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/fp/either.dart';
import '../../model/agendado_model.dart';
import '../../model/user_model.dart';
import 'schedule_state.dart';

part 'schedule_vm.g.dart';

@riverpod
class ScheduleVm extends _$ScheduleVm {
  @override
  ScheduleState build() => ScheduleState.initial();

  void hourSelect(int hour) {
    if (hour == state.scheduleHour) {
      state = state.copyWith(
        scheduleHour: null,
      );
    } else {
      state = state.copyWith(
        scheduleHour: hour,
      );
    }
  }

  void dateSelect(DateTime date) {
    state = state.copyWith(
      scheduleDate: date,
    );
  }

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final ScheduleState(:scheduleDate, :scheduleHour) = state;
    final scheduleRepository = ref.read(scheduleRepositoryProvider);
    final AgendadoModel(id: agendadoId) =
        await ref.watch(getMyAgendadoProvider.future);
    final dto = (
      agendadoId: agendadoId,
      userId: userModel.id,
      clientName: clientName,
      date: scheduleDate!,
      time: scheduleHour!,
    );

    final scheduleResult = await scheduleRepository.scheduleClient(dto);
    switch (scheduleResult) {
      case Success():
        state = state.copyWith(status: ScheduleStateStatus.success);

      case Failure():
        state = state.copyWith(status: ScheduleStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
