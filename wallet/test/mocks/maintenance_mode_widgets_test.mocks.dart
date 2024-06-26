// Mocks generated by Mockito 5.3.2 from annotations
// in pylons_wallet/test/widget_testing/components/maintenance_mode_widgets_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart'
    as _i3;
import 'package:pylons_wallet/utils/base_env.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBaseEnv_0 extends _i1.SmartFake implements _i2.BaseEnv {
  _FakeBaseEnv_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RemoteConfigService].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteConfigService extends _i1.Mock
    implements _i3.RemoteConfigService {
  MockRemoteConfigService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<dynamic> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i2.BaseEnv getBaseEnv() => (super.noSuchMethod(
        Invocation.method(
          #getBaseEnv,
          [],
        ),
        returnValue: _FakeBaseEnv_0(
          this,
          Invocation.method(
            #getBaseEnv,
            [],
          ),
        ),
      ) as _i2.BaseEnv);
  @override
  String getAndroidAppVersion() => (super.noSuchMethod(
        Invocation.method(
          #getAndroidAppVersion,
          [],
        ),
        returnValue: '',
      ) as String);
  @override
  String getIOSAppVersion() => (super.noSuchMethod(
        Invocation.method(
          #getIOSAppVersion,
          [],
        ),
        returnValue: '',
      ) as String);
  @override
  bool getMaintenanceMode() => (super.noSuchMethod(
        Invocation.method(
          #getMaintenanceMode,
          [],
        ),
        returnValue: false,
      ) as bool);
}
