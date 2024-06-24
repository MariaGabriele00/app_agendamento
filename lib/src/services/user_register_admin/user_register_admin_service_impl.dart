import 'package:app_agendamento/src/core/exceptions/service_expection.dart';
import 'package:app_agendamento/src/core/fp/either.dart';
import 'package:app_agendamento/src/core/fp/nil.dart';
import 'package:app_agendamento/src/services/user_login/user_login_service.dart';

import '../../repositories/user/user_repository.dart';
import 'user_register_admin_service.dart';

class UserRegisterAdminServiceImpl implements UserRegisterAdminService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisterAdminServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });
  @override
  Future<Either<ServiceExpection, Nil>> execute(
      ({
        String name,
        String email,
        String password,
      }) userData) async {
    final registerResult = await userRepository.registerAdmin(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        return Failure(ServiceExpection(message: exception.message));
    }
  }
}
