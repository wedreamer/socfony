import 'package:cloudbase/cloudbase.dart' as cloudbase
    show CloudBase, CloudBaseCoreCredentials, CloudBaseCoreSecurityCredentials;
import 'package:snsmax/config.dart';

export 'package:cloudbase/cloudbase.dart' hide CloudBase;

class CloudBase extends cloudbase.CloudBase {
  static CloudBase _instance;

  CloudBase._(cloudbase.CloudBaseCoreCredentials credentials)
      : super(credentials);

  factory CloudBase() {
    if (_instance is! CloudBase) {
      final security = cloudbase.CloudBaseCoreSecurityCredentials(
          C__CLOUDBASE_SECURITY_KEY, C__CLOUDBASE_SECURITY_VERSION);
      final credentials = cloudbase.CloudBaseCoreCredentials(
          C__CLOUDBASE_ENV_ID,
          security: security);
      _instance = CloudBase._(credentials);
    }

    return _instance;
  }

  static CloudBase get instance => CloudBase();
}
