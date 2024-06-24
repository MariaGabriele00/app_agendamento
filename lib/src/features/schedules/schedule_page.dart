import 'package:app_agendamento/src/core/ui/agendado_icons.dart';
import 'package:app_agendamento/src/core/ui/helpers/form_helper.dart';
import 'package:app_agendamento/src/core/ui/helpers/messages.dart';
import 'package:app_agendamento/src/core/ui/widgets/hours_panel.dart';
import 'package:app_agendamento/src/features/schedules/schedule_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/ui/constants.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import '../../model/user_model.dart';
import 'schedule_state.dart';
import 'widgets/schedule_calendar.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var dateFormat = DateFormat('dd/MM/yyyy');
  var showCalendar = false;
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    final scheduleVM = ref.watch(scheduleVmProvider.notifier);
    final employeeData = switch (userModel) {
      UserModelADM(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours,
        ),
    };

    ref.listen(scheduleVmProvider.select((state) => state.status), (_, status) {
      switch (status) {
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.success:
          Messages.showSuccess('Agendamento realizado com sucesso', context);
          Navigator.of(context).pop();
        case ScheduleStateStatus.error:
          Messages.showError('Erro ao realizar agendamento', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                const AvatarWidget(hideUploadButton: true),
                const SizedBox(height: 24),
                Text(
                  userModel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 37),
                TextFormField(
                  controller: clientEC,
                  validator: Validatorless.required('Cliente obrigatório'),
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: dateEC,
                  validator: Validatorless.required(
                      'Selecione uma data de agendamento'),
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      showCalendar = true;
                    });
                    context.unfocus();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Selecione uma data',
                    hintText: 'Selecione uma data',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: Icon(
                      AgendadoIcons.calendar,
                      color: ColorsConstants.pink,
                      size: 18,
                    ),
                  ),
                ),
                Offstage(
                  offstage: !showCalendar,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      ScheduleCalendar(
                        cancelPressed: () {
                          setState(() {
                            showCalendar = false;
                          });
                        },
                        salvarPressed: (DateTime value) {
                          setState(() {
                            dateEC.text = dateFormat.format(value);
                            scheduleVM.dateSelect(value);
                            showCalendar = false;
                          });
                        },
                        workDays: employeeData.workDays,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                HoursPanel.singleSelection(
                  startTime: 6,
                  endTime: 23,
                  onHourPressed: scheduleVM.hourSelect,
                  enabledTimes: employeeData.workHours,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError('Dados incompletos', context);
                      case true:
                        final hourSelected =
                            ref.watch(scheduleVmProvider.select(
                          (state) => state.scheduleHour != null,
                        ));
                        if (hourSelected) {
                          scheduleVM.register(
                            userModel: userModel,
                            clientName: clientEC.text,
                          );
                        } else {
                          Messages.showError(
                              'Selecione um horário de atendimento', context);
                        }
                    }
                  },
                  child: const Text(
                    'AGENDAR',
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
