import 'package:together/features/auth/domain/entities/app_user.dart';
import 'package:together/features/auth/domain/repository/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) {
    // TODO: implement registerWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
