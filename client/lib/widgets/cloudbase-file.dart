import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/provider/cached-network-file.dart';

typedef CloudBaseFileWidgetBuilder = Widget Function(
    BuildContext, AsyncSnapshot<DownloadMetadata>);

class CloudBaseFile extends StatelessWidget {
  const CloudBaseFile({
    @required this.fileId,
    @required this.builder,
    Key key,
  }) : super(key: key);

  final String fileId;
  final CloudBaseFileWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return context.select<CachedNetworkFileProvider, Widget>(
        (CachedNetworkFileProvider provider) =>
            _widgetBuilder(context, provider));
  }

  Widget _widgetBuilder(
      BuildContext context, CachedNetworkFileProvider provider) {
    if (provider.containsKey(fileId)) {
      return builder(
          context,
          AsyncSnapshot<DownloadMetadata>.withData(
              ConnectionState.done, provider[fileId]));
    }

    return FutureBuilder<DownloadMetadata>(
      builder: builder,
      future: _fetchFileMeta(provider),
    );
  }

  Future<DownloadMetadata> _fetchFileMeta(
      CachedNetworkFileProvider provider) async {
    if (provider.containsKey(fileId)) {
      return provider[fileId];
    }

    CloudBaseStorageRes<List<DownloadMetadata>> result =
        await CloudBase().storage.getFileDownloadURL([fileId]);
    provider.insertOrUpdate(result.data);

    return result.data.where((element) => element.fileId == fileId).last;
  }
}
