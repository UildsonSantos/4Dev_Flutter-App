import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizedHttpClientDecorator implements HttpClient {
  DeleteSecureCacheStorage deleteSecureCacheStorage;
  FetchSecureCacheStorage fetchSecureCacheStorage;

  HttpClient decoratee;

  AuthorizedHttpClientDecorator({
    @required this.deleteSecureCacheStorage,
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });

  @override
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});

      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
    } on HttpError {
      rethrow;
    } catch (error) {
      await deleteSecureCacheStorage.deleteSecure('token');
      throw HttpError.forbidden;
    }
  }
}
