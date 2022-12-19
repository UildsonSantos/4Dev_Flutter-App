import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/local_storage_adapter_factory.dart';
import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
