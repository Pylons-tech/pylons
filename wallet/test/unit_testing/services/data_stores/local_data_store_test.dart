import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../mocks/mock_local_data_source.dart';

void main() {
  final localDataSource = MockLocalDataSource();
  GetIt.I.registerSingleton<LocalDataSource>(localDataSource);

  test('should get weather user getting do i accept policy or not', () {
    final response = localDataSource.getUserAcceptPolicies();
    expect(true, response);
  });

  test('should system save that user accepted policies or not', () async {
    final response = await localDataSource.saveUserAcceptPolicies();
    expect(true, response);
  });
}
