import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/decorator.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizedHttpClientDecorator sut;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() => mockTokenCall().thenThrow(Exception());

  PostExpectation mockHttpResponseCall() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      );

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) =>
      mockHttpResponseCall().thenThrow(error);

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizedHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockToken();
    mockHttpResponse();
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);

    await sut.request(
      url: url,
      method: method,
      body: body,
      headers: {'any_header': 'any_value'},
    );
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token, 'any_header': 'any_value'},
    )).called(1);
  });

  test('should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('should throw ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    mockTokenError();
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });
}
