import 'package:local_auth/local_auth.dart';
import 'package:pylons_wallet/utils/local_auth_helper.dart';

class MockLocalAuthHelper extends LocalAuthHelper {
  @override
  Future<bool> authenticate() {
    return Future.value(true);
  }

  @override
  Future<BiometricType> isBiometricAvailable() {
    return Future.value(BiometricType.fingerprint);
  }
}
