import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/either.dart';
import 'customer_register_state.dart';

part 'customer_register_vm.g.dart';

@riverpod
class CustomerRegisterVm extends _$CustomerRegisterVm {
  @override
  CustomerRegisterState build() => CustomerRegisterState.initial();

  void addOrRemoveOpenDay(String weekDay) {
    final openingDays = state.openingDays;
    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }

    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHour(int hour) {
    final openingHours = state.openingHours;
    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }

    state = state.copyWith(openingHours: openingHours);
  }

  Future<void> register(String name, String email) async {
    final repository = ref.watch(agendadoRespositoryProvider);
    final CustomerRegisterState(:openingDays, :openingHours) = state;
    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );

    final registerResult = await repository.save(dto);

    switch (registerResult) {
      case Success():
        ref.invalidate(getMyAgendadoProvider);
        state = state.copyWith(status: CustomerRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: CustomerRegisterStateStatus.error);
    }
  }
}
