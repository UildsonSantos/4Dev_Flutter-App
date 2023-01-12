import '../../../data/http/http.dart';
import '../../decorators/decorator.dart';
import '../../factories/factories.dart';

HttpClient makeAuthorizedHttpClientDecorator() => AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      decoratee: makeHttpAdapter(),
    );
