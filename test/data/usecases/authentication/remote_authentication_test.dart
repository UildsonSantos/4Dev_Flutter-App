import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  setUp(() {
    apiResult = ApiFactory.makeAccountJson();
    params = ParamsFactory.makeAuthentication();

    httpClient = HttpClientSpy();
    httpClient.mockRequest(apiResult);
    
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test(
    'should call HttpClient with correct method',
    () async {
      // act
      await sut.auth(params);

      // assert
      verify(() => httpClient.request(
            url: url,
            method: 'post',
            body: {'email': params.email, 'password': params.secret},
          ));
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 400',
    () async {
      httpClient.mockRequestError(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 404',
    () async {
      httpClient.mockRequestError(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 500',
    () async {
      httpClient.mockRequestError(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'should throw invalidCredentialError if HttpClient returs 401',
    () async {
      httpClient.mockRequestError(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'should return an Account if HttpClient returns 200',
    () async {
      final account = await sut.auth(params);

      expect(account.token, apiResult['accessToken']);
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      httpClient.mockRequest({'invalid_key': 'invalid_value'});

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
