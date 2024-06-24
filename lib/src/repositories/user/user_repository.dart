import 'package:app_agendamento/src/core/fp/either.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/nil.dart';
import '../../model/user_model.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login(
    String email,
    String password,
  );

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(
    ({
      String name,
      String email,
      String password,
    }) userData,
  );

  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
    int agendadoId,
  );

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<int> workhours,
        List<String> workdays,
      }) userModel);

  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int agendadoId,
        String name,
        String email,
        String password,
        List<String> workdays,
        List<int> workhours,
      }) userModel);
}
