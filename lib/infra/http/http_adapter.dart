import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({
    required this.client,
  });

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(
        {'content-type': 'application/json', 'accept': 'application/json'},
      );
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;

    try {
      if (method == 'post') {
        response = await client
            .post(Uri.parse(url), headers: defaultHeaders, body: jsonBody)
            .timeout(Duration(seconds: 10));
      } else if (method == 'get') {
        response = await client
            .get(Uri.parse(url), headers: defaultHeaders)
            .timeout(Duration(seconds: 10));
      } else if (method == 'put') {
        futureResponse =
            client.put(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      }

      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 10));
      }
    } catch (error) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        return throw HttpError.badRequest;
      case 401:
        return throw HttpError.unauthorized;
      case 403:
        return throw HttpError.forbidden;
      case 404:
        return throw HttpError.notFound;

      default:
        throw HttpError.serverError;
    }
  }
}
