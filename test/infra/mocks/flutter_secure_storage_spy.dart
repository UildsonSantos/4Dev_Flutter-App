import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    this.mockDeleteSecure();
    this.mockSaveSecure();
  }

  When mockDeleteSecureCall() => when(() => this.delete(key: any(named: 'key')));
  void mockDeleteSecure() => this.mockDeleteSecureCall().thenAnswer((_) async => _);
  void mockDeleteSecureError() =>
      when(() => this.mockDeleteSecureCall().thenThrow(Exception()));

  When mockSaveSecureCall() => when(
      () => this.write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSaveSecure() => this.mockSaveSecureCall().thenAnswer((_) async => _);
  void mockSaveSecureError() =>
      when(() => this.mockSaveSecureCall().thenThrow(Exception()));

  When mockFetchSecureCall() => when(() => this.read(key: any(named: 'key')));
  void mockFetchSecure(String? data) =>
      this.mockFetchSecureCall().thenAnswer((_) async => data);
  void mockFetchSecureError() =>
      when(() => this.mockFetchSecureCall().thenThrow(Exception()));
}


