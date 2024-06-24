import 'package:app_agendamento/src/core/exceptions/auth_exception.dart';
import 'package:app_agendamento/src/core/exceptions/service_expection.dart';
import 'package:app_agendamento/src/repositories/user/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/local_storage_keys.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import 'user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;

  UserLoginServiceImpl({
    required this.userRepository,
  });

  @override
  Future<Either<ServiceExpection, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);

    switch (loginResult) {
      case Success(value: final accessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageKeys.accessToken, accessToken);
        return Success(nil);
      case Failure(:final exception):
        return switch (exception) {
          AuthError() =>
            Failure(ServiceExpection(message: 'Erro ao realizar login!')),
          AuthUnauthorizedException() =>
            Failure(ServiceExpection(message: 'E-mail ou senha inválidos!')),
          AuthException() => throw UnimplementedError(),
        };
    }
  }
}
