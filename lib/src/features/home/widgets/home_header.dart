import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:app_agendamento/src/core/ui/constants.dart';
import 'package:app_agendamento/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/agendado_icons.dart';
import '../../../core/ui/widgets/agendamento_loader.dart';

class HomeHeader extends ConsumerWidget {
  final bool hideFilter;

  const HomeHeader({
    super.key,
    this.hideFilter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendados = ref.watch(getMyAgendadoProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(ImageConstants.backgroundChair),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          agendados.maybeWhen(
            data: (agendadoData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      agendadoData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'editar',
                      style: TextStyle(
                        color: ColorsConstants.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 78),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).logout();
                    },
                    icon: const Icon(
                      AgendadoIcons.exit,
                      color: ColorsConstants.pink,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
            orElse: () {
              return const Center(
                child: AgendamentoLoader(),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Bem Vindo!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Agende um Cliente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: const SizedBox(height: 24),
          ),
          Offstage(
            offstage: hideFilter,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('Buscar Colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child: Icon(
                    AgendadoIcons.search,
                    color: ColorsConstants.pink,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
