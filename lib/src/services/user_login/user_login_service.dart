import 'package:app_agendamento/src/core/exceptions/service_expection.dart';

import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceExpection, Nil>> execute(
    String email,
    String password,
  );
}
