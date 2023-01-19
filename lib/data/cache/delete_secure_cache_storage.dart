import 'package:meta/meta.dart';

abstract class DeleteSecureCacheStorage {
  Future<void> deleteSecure(String key);
}
