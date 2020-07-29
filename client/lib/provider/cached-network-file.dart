import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:snsmax/cloudbase.dart';
import 'collection.dart';

class CachedNetworkFileProvider
    extends BaseCollectionProvider<String, DownloadMetadata> {
  static CachedNetworkFileProvider _instance;

  factory CachedNetworkFileProvider() {
    if (_instance == null) {
      _instance = CachedNetworkFileProvider._();
    }
    return _instance;
  }

  CachedNetworkFileProvider._();

  @override
  String get collectionName => throw UnimplementedError();

  @override
  String toCollectionId(DownloadMetadata element) => toDocId(element);

  @override
  String toDocId(DownloadMetadata element) => element.fileId;

  @override
  void watcher(Iterable<DownloadMetadata> elements) {}

  @override
  bool get usingCustomWatchDoc => true;

  @override
  Future<DownloadMetadata> customWatchDoc(String key) async {
    CloudBaseStorageRes<List<DownloadMetadata>> result =
        await CloudBase().storage.getFileDownloadURL([key]);
    originInsertOrUpdate(result.data);

    return collections[key];
  }
}
