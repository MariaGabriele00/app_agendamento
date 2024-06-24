import 'dart:developer';

import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:app_agendamento/src/core/ui/agendado_icons.dart';
import 'package:app_agendamento/src/core/ui/constants.dart';
import 'package:app_agendamento/src/features/home/adm/home_adm_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/widgets/agendamento_loader.dart';
import '../widgets/home_header.dart';
import 'home_adm_vm.dart';
import 'widgets/home_employee_tile.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: ColorsConstants.pink,
          onPressed: () async {
            await Navigator.of(context).pushNamed('/employee/register');
            ref.invalidate(getMeProvider);
            ref.invalidate(homeAdmVmProvider);
          },
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 12,
            child: Icon(
              AgendadoIcons.addEmployee,
              color: ColorsConstants.pink,
            ),
          )),
      body: homeState.when(
        data: (HomeAdmState data) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      HomeEmployeeTile(employee: data.employees[index]),
                  childCount: data.employees.length,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log('Erro ao carregar colaboradores',
              error: error, stackTrace: stackTrace);
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        },
        loading: () {
          return const AgendamentoLoader();
        },
      ),
    );
  }
}
