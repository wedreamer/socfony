import 'package:fans/cloudbase.dart';
import 'package:fans/cloudbase/database/TcbDbCollectionsProvider.dart';
import 'package:fans/models/BaseModel.dart';

class TcbStorageFileMockDbQueryModel implements AbstractBaseModel {
  /// CloudBase storage file id
  final String fileId;

  /// CloudBase storage file download URI
  final Uri uri;

  /// Create CloudBase storage File mock
  /// database collection doc.
  const TcbStorageFileMockDbQueryModel(this.fileId, this.uri);

  /// Mock [AbstractBaseModel] id.
  @override
  String get id => fileId;
}

const kTcbStorageFileMockCollectionName = 'mock://storage/files';

class TcbStorageFileMockDbQuery {
  const TcbStorageFileMockDbQuery._();

  /// Get mock database collection name.
  static String get mockCollectionName => kTcbStorageFileMockCollectionName;

  /// Register the query to [TcbDbCollectionsProvider],
  /// Using [Provider](https://pub.dev/packages/provider) Selector
  /// query the file.
  static void register() {
    TcbDbCollectionsProvider.registerQuery<TcbStorageFileMockDbQueryModel>(
        mockCollectionName, (_, String fileId) async => await query(fileId));
  }

  /// Query TCB storage file, return a [TcbStorageFileMockDbQueryModel]
  static Future<TcbStorageFileMockDbQueryModel> query(String fileId) async {
    CloudBaseStorageRes<List<DownloadMetadata>> response =
        await CloudBase().storage.getFileDownloadURL([fileId]);
    Iterable<TcbStorageFileMockDbQueryModel> files = response.data
        .map<TcbStorageFileMockDbQueryModel>((e) =>
            TcbStorageFileMockDbQueryModel(e.fileId, Uri.parse(e.downloadUrl)));
    return files.firstWhere((element) => element.fileId == fileId);
  }
}
