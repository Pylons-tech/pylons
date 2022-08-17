import 'package:easy_localization/easy_localization.dart';
import 'package:local_auth/local_auth.dart';

abstract class LocalAuthHelper {
  /// This method checks whether the finger print is available or not
  /// [Output] : [BiometricType] returns the type of biometric that is available
  Future<BiometricType> isBiometricAvailable();

  /// This method authenticates the user based on biometric
  /// [Output] : [bool] shows whether the authentication is successful or not
  Future<bool> authenticate();
}

class LocalAuthHelperImp implements LocalAuthHelper {
  final LocalAuthentication localAuth;

  LocalAuthHelperImp(this.localAuth);

  @override
  Future<BiometricType> isBiometricAvailable() async {
    if (!await localAuth.canCheckBiometrics) {
      throw 'something_wrong'.tr();
    }

    final biometricList = await localAuth.getAvailableBiometrics();

    if (biometricList.isEmpty) {
      throw 'something_wrong'.tr();
    }


    if(deviceHasBiometric(biometricList)){
      return BiometricType.fingerprint;
    }

    return biometricList.first;


  }

  bool deviceHasBiometric(List<BiometricType> biometricList) => biometricList.length >1  && biometricList.contains(BiometricType.fingerprint);

  @override
  Future<bool> authenticate() async {
    return  localAuth.authenticate(
      localizedReason: 'authenticate'.tr(),
    );
  }
}
