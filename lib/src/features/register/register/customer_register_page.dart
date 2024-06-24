import 'package:app_agendamento/src/core/ui/helpers/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/hours_panel.dart';
import '../../../core/ui/widgets/weekdays_panel.dart';
import 'customer_register_state.dart';
import 'customer_register_vm.dart';

class CustomerRegisterPage extends ConsumerStatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  ConsumerState<CustomerRegisterPage> createState() =>
      _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends ConsumerState<CustomerRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerRegisterVm = ref.watch(customerRegisterVmProvider.notifier);

    ref.listen(customerRegisterVmProvider, (_, state) {
      switch (state.status) {
        case CustomerRegisterStateStatus.initial:
          break;
        case CustomerRegisterStateStatus.success:
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
        case CustomerRegisterStateStatus.error:
          Messages.showError('Erro ao registrar estabelecimento', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar estabelecimento',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextFormField(
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido')
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                ),
                const SizedBox(height: 24),
                WeekdaysPanel(
                  onDayPressed: (value) {
                    customerRegisterVm.addOrRemoveOpenDay(value);
                  },
                ),
                const SizedBox(height: 24),
                HoursPanel(
                  startTime: 6,
                  endTime: 23,
                  onHourPressed: (int value) {
                    customerRegisterVm.addOrRemoveOpenHour(value);
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError('Formulário inválido', context);
                      case true:
                        customerRegisterVm.register(nameEC.text, emailEC.text);
                    }
                  },
                  child: const Text(
                    'CADASTRAR ESTABELECIMENTO',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
