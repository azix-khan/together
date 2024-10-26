import 'dart:typed_data';

abstract class StorageRepo {
  // upload profile pic on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String filename);

  // upload profile pic on web platforms
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String filename);
}
