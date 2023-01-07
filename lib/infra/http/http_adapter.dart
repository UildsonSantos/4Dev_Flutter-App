import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({@required this.client});

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(
        {'content-type': 'application/json', 'accept': 'application/json'},
      );
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);

    try {
      if (method == 'post') {
        response =
            await client.post(url, headers: defaultHeaders, body: jsonBody);
      } else if (method == 'get') {
        response = await client.get(url, headers: defaultHeaders);
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
