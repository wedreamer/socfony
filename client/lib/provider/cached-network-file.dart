import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'collection.dart';

class CachedNetworkFileProvider
    extends BaseCollectionProvider<String, DownloadMetadata> {
  @override
  String get collectionName => throw UnimplementedError();

  @override
  String toCollectionId(DownloadMetadata element) => toDocId(element);

  @override
  String toDocId(DownloadMetadata element) => element.fileId;

  @override
  void watcher(Iterable<DownloadMetadata> elements) {}
}
