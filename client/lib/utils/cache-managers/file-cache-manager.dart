import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cache;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileCacheManager extends cache.BaseCacheManager {
  static const String key = "snsmax";

  static cache.BaseCacheManager _instance;

  factory FileCacheManager() {
    if (_instance == null) {
      _instance = new FileCacheManager._();
    }
    return _instance;
  }

  FileCacheManager._()
      : super(
          key,
          maxAgeCacheObject: Duration(days: 7),
          maxNrOfCacheObjects: 10000,
        );

  @override
  Future<String> getFilePath() async {
    Directory directory = await getTemporaryDirectory();

    return path.join(directory.path, key, "network-cached-files");
  }
}
