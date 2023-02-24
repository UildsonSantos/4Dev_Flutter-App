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
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;


  setUp(() {
    apiResult = ApiFactory.makeAccountJson();
    params = ParamsFactory.makeAddAccount();
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();
    httpClient.mockRequest(apiResult);
    
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct method', () async {
    await sut.add(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'name': params.name,
            'password': params.password,
            'passwordConfirmation': params.passwordConfirmation,
          },
        ));
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw invalidCredentialError if HttpClient returns 403',
      () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('should return an Account if HttpClient returns 200', () async {
    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
    'should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      httpClient.mockRequest({'invalid_key': 'invalid_value'});

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
