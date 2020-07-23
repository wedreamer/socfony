import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

export 'package:cloudbase_auth/cloudbase_auth.dart';
export 'package:cloudbase_core/cloudbase_core.dart';
export 'package:cloudbase_database/cloudbase_database.dart';
export 'package:cloudbase_function/cloudbase_function.dart';
export 'package:cloudbase_storage/cloudbase_storage.dart';

class _CloudBaseInstance {
  const _CloudBaseInstance._();

  // Cloud base initialized.
  static bool initialized = false;

  // Storage cloud base core instance.
  static CloudBaseCore core;

  // Storage Cloud base auth instance.
  static CloudBaseAuth auth;

  // Storage function instance
  static CloudBaseFunction function;

  // Cache storage instance.
  static CloudBaseStorage storage;

  // Cache CloudBase Database instance
  static CloudBaseDatabase database;

  // Init Cloud Base.
  static void init() {
    if (initialized == true) {
      return;
    }

    // Init Cloud base core.
    core = CloudBaseCore.init({
      "env": "snsmax-1e572d",
      "appAccess": {"key": "1a5384f2f5bbd9bb2aaf0891309fb45a", "version": "1"},
    });

    // Init Cloud base auth.
    auth = CloudBaseAuth(core);

    // Create function instance
    function = CloudBaseFunction(core);

    // Create Storage instance
    storage = CloudBaseStorage(core);

    // Create CloudBase database instance
    database = CloudBaseDatabase(core);

    // Set init value
    initialized = true;
  }
}

class CloudBase {
  CloudBase() {
    if (_CloudBaseInstance.initialized != true) {
      _CloudBaseInstance.init();
    }
  }

  /// Get cloud base instance status.
  bool get initialized => _CloudBaseInstance.initialized;

  /// Get cloud base core instance.
  CloudBaseCore get core => _CloudBaseInstance.core;

  /// Get cloud base auth instance.
  CloudBaseAuth get auth => _CloudBaseInstance.auth;

  /// Get CloudBase storage instance.
  CloudBaseStorage get storage => _CloudBaseInstance.storage;

  /// Get CloudBase database instance
  CloudBaseDatabase get database => _CloudBaseInstance.database;

  /// Run CloudBase function
  /// [name] is CloudBase function name.
  /// [params] is [Map] type
  Future<CloudBaseResponse> fun(String name,
      [Map<String, dynamic> params]) async {
    return await _CloudBaseInstance.function.callFunction(name, params);
  }
}
