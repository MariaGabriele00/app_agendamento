import 'package:app_agendamento/src/core/providers/application_providers.dart';
import 'package:app_agendamento/src/services/user_register_admin/user_register_admin_service.dart';
import 'package:app_agendamento/src/services/user_register_admin/user_register_admin_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_providers.g.dart';

@riverpod
UserRegisterAdminService userRegisterAdminService(
        UserRegisterAdminServiceRef ref) =>
    UserRegisterAdminServiceImpl(
      userRepository: ref.watch(userRepositoryProvider),
      userLoginService: ref.watch(userLoginServiceProvider),
    );
