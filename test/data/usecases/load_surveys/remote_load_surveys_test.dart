import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/remote_survey_model.dart';

import 'package:fordev/domain/entities/entities.dart';


class RemoteLoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse.map((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  String url;
  List<Map> listToTest;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
        ),
      );

  void mockHttpData(List<Map> data) {
    listToTest = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('should return surveys on 200', () async {
    final surveys = await sut.load();

    final responseSurveys = [
      SurveyEntity(
        id: listToTest[0]['id'],
        question: listToTest[0]['question'],
        dateTime: DateTime.parse(listToTest[0]['date']),
        didAnswer: listToTest[0]['didAnswer'],
      ),
      SurveyEntity(
        id: listToTest[1]['id'],
        question: listToTest[1]['question'],
        dateTime: DateTime.parse(listToTest[1]['date']),
        didAnswer: listToTest[1]['didAnswer'],
      ),
      SurveyEntity(
        id: listToTest[2]['id'],
        question: listToTest[2]['question'],
        dateTime: DateTime.parse(listToTest[2]['date']),
        didAnswer: listToTest[2]['didAnswer'],
      )
    ];
    expect(surveys, responseSurveys);
  });
}
