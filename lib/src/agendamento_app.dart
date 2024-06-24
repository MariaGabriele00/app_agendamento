import 'package:app_agendamento/src/core/ui/agendado_nav_global_key.dart';
import 'package:app_agendamento/src/features/register/user/user_register_page.dart';
import 'package:app_agendamento/src/features/splash/splash_page.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/ui/agendamento_theme.dart';
import 'core/ui/widgets/agendamento_loader.dart';
import 'features/auth/login/login_page.dart';
import 'features/employee/register/employee_register_page.dart';
import 'features/employee/schedule/employee_schedule_page.dart';
import 'features/home/adm/home_adm_page.dart';
import 'features/home/employee/home_employee_page.dart';
import 'features/register/register/customer_register_page.dart';
import 'features/schedules/schedule_page.dart';

class AgendamentoApp extends StatelessWidget {
  const AgendamentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const AgendamentoLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Agendamentos',
          theme: AgendamentoTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          navigatorKey: AgendadoNavGlobalKey.instance.navKey,
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
            '/auth/register/user': (_) => const UserRegisterPage(),
            '/auth/register/company': (_) => const CustomerRegisterPage(),
            '/home/adm': (_) => const HomeAdmPage(),
            '/home/employee': (_) => const HomeEmployeePage(),
            '/employee/register': (_) => const EmployeeRegisterPage(),
            '/employee/schedule': (_) => const EmployeeSchedulePage(),
            '/schedule': (_) => const SchedulePage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          locale: const Locale('pt', 'BR'),
        );
      },
    );
  }
}
