import 'package:app_agendamento/src/core/exceptions/service_expection.dart';
import 'package:app_agendamento/src/core/fp/either.dart';
import 'package:app_agendamento/src/core/fp/nil.dart';

abstract interface class UserRegisterAdminService {
  Future<Either<ServiceExpection, Nil>> execute(
      ({
        String name,
        String email,
        String password,
      }) userData);
}
