import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test(
    'should call HttpClient with correct method',
    () async {
      final params = AuthenticationParams(
          email: faker.internet.email(), secret: faker.internet.password());
      // act
      await sut.auth(params);

      // assert
      verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret},
      ));
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 400',
    () async {
      when(
        httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')),
      ).thenThrow(HttpError.badRequest);

      final params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
