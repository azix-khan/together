import 'package:together/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);
}
