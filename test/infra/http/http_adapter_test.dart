import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

import 'package:fordev/infra/http/http.dart';

import '../mocks/mocks.dart';

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('shared', () {
    test('should throw SeverError if invalid method is provided ', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    test('should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );
      verify(
        () => client.post(Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}'),
      );

      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
        headers: {'any_header': 'any_value'},
      );
      verify(
        () => client.post(Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
              'any_header': 'any_value',
            },
            body: '{"any_key":"any_value"}'),
      );
    });

    test('should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(any(), headers: any(named: 'headers')));
    });

    test('should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if post returns 200 with no data', () async {
      client.mockPost(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('should return null if post returns 204', () async {
      client.mockPost(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('should return null if post returns 204 with data', () async {
      client.mockPost(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('should return BadRequestError if post returns 400', () async {
      client.mockPost(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if post returns 400', () async {
      client.mockPost(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if post returns 401', () async {
      client.mockPost(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if post returns 403', () async {
      client.mockPost(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if post returns 404', () async {
      client.mockPost(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if post returns 500', () async {
      client.mockPost(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('should return ServerError if post throws', () async {
      client.mockPostError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    test('should call get with correct values', () async {
      await sut.request(
        url: url,
        method: 'get',
      );
      final headersTypeOne = {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
      verify(() => client.get(Uri.parse(url), headers: headersTypeOne));

      await sut.request(
        url: url,
        method: 'get',
        headers: {'any_header': 'any_value'},
      );
      final headersTypeTwo = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'any_header': 'any_value',
      };
      verify(() => client.get(Uri.parse(url), headers: headersTypeTwo));
    });

    test('should return data if get returns 200', () async {
      final response = await sut.request(url: url, method: 'get');

      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if get returns 200 with no data', () async {
      client.mockGet(200, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('should return null if get returns 204', () async {
      client.mockGet(204, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('should return null if get returns 204 with data', () async {
      client.mockGet(204);

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('should return BadRequestError if get returns 400 with body empty',
        () async {
      client.mockGet(400, body: '');

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if get returns 400', () async {
      client.mockGet(400);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if get returns 401', () async {
      client.mockGet(401);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if get returns 403', () async {
      client.mockGet(403);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if get returns 404', () async {
      client.mockGet(404);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if get returns 500', () async {
      client.mockGet(500);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });

    test('should return ServerError if get throws', () async {
      client.mockGetError();

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('put', () {
    test('should call put with correct values', () async {
      await sut
          .request(url: url, method: 'put', body: {'any_key': 'any_value'});
      verify(
        () => client.put(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}',
        ),
      );

      await sut.request(
        url: url,
        method: 'put',
        body: {'any_key': 'any_value'},
        headers: {'any_header': 'any_value'},
      );

      verify(
        () => client.put(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });

    test('should call put without body', () async {
      await sut.request(url: url, method: 'put');

      verify(() => client.put(any(), headers: any(named: 'headers')));
    });

    test('should return data if put returns 200', () async {
      final response = await sut.request(url: url, method: 'put');

      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if put returns 200 with no data', () async {
      client.mockPut(200, body: '');

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('should return null if put returns 204', () async {
      client.mockPut(204, body: '');

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('should return null if put returns 204 with data', () async {
      client.mockPut(204);

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('should return BadRequestError if put returns 400', () async {
      client.mockPut(400, body: '');

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if put returns 400', () async {
      client.mockPut(400);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if put returns 401', () async {
      client.mockPut(401);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if put returns 403', () async {
      client.mockPut(403);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if put returns 404', () async {
      client.mockPut(404);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if put returns 500', () async {
      client.mockPut(500);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));
    });

    test('should return ServerError if put throws', () async {
      client.mockPutError();

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
