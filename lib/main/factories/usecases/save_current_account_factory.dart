import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../cache/cache.dart';
import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() => LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeLocalStorageAdapter(),
    );
