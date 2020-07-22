import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/foundation.dart';

class CachedNetworkFileProvider with ChangeNotifier {
  Map<String, DownloadMetadata> _files = {};
  Map<String, DownloadMetadata> get files => _files;

  DownloadMetadata fetchById(String id) => files[id];

  void cache(List<DownloadMetadata> value) {
    value?.forEach((element) {
      _files.putIfAbsent(element.fileId, () => element);
    });
    notifyListeners();
  }
}
