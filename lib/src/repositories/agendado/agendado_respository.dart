import 'package:app_agendamento/src/core/exceptions/repository_exception.dart';
import 'package:app_agendamento/src/model/agendado_model.dart';

import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../model/user_model.dart';

abstract interface class AgendadoRespository {
  Future<Either<RepositoryException, Nil>> save(
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data);

  Future<Either<RepositoryException, AgendadoModel>> getMyAgendado(
      UserModel userModel);
}
