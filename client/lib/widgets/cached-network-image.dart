import 'package:cached_network_image/cached_network_image.dart' as cache;
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/provider/cached-network-file.dart';
import 'package:snsmax/utils/cache-managers/file-cache-manager.dart';

typedef ProgressIndicatorBuilder = Widget Function(
    BuildContext, DownloadProgress);
typedef LoadingErrorWidgetBuilder = Widget Function(
    BuildContext, dynamic error);

class CachedNetworkImage extends StatelessWidget {
  const CachedNetworkImage({
    Key key,
    @required this.fileId,
    this.rule,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    this.fit,
    this.width,
    this.height,
  }) : super(key: key);

  final String fileId;
  final String rule;
  final ProgressIndicatorBuilder progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder errorBuilder;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double height;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return context.select<CachedNetworkFileProvider, Widget>(
        (CachedNetworkFileProvider value) => widgetBuilder(context, value));
  }

  Widget widgetBuilder(
      BuildContext context, CachedNetworkFileProvider provider) {
    if (provider.containsKey(fileId)) {
      return futureWidgetBuilder(
        context,
        AsyncSnapshot<DownloadMetadata>.withData(
          ConnectionState.done,
          provider[fileId],
        ),
      );
    }

    return FutureBuilder<DownloadMetadata>(
      future: fetchFileMeta(provider),
      builder: futureWidgetBuilder,
    );
  }

  Widget futureWidgetBuilder(
      BuildContext context, AsyncSnapshot<DownloadMetadata> snapshot) {
    DownloadMetadata meta = snapshot.data;
    if (snapshot.connectionState == ConnectionState.waiting) {
      return defaultProgressBuilder(context, DownloadProgress(fileId, 1, 0));
    } else if (snapshot.hasError) {
      return defaultErrorBuilder(context, snapshot.error);
    }
    return cache.CachedNetworkImage(
      imageUrl: rule is String && rule.isNotEmpty
          ? ("${meta.downloadUrl}" "?" "$rule")
          : meta.downloadUrl,
      progressIndicatorBuilder:
          (BuildContext context, _, DownloadProgress progress) =>
              defaultProgressBuilder(context, progress),
      errorWidget: (BuildContext context, _, dynamic error) =>
          defaultErrorBuilder(context, error),
      fit: fit,
      useOldImageOnUrlChange: true,
      cacheManager: FileCacheManager(),
      width: width,
      height: height,
    );
  }

  Widget defaultErrorBuilder(BuildContext context, dynamic error) {
    if (errorBuilder is LoadingErrorWidgetBuilder) {
      return errorBuilder(context, error);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context).disabledColor,
      ),
    );
  }

  Widget defaultProgressBuilder(
      BuildContext context, DownloadProgress progress) {
    if (progressIndicatorBuilder is ProgressIndicatorBuilder) {
      return progressIndicatorBuilder(context, DownloadProgress(fileId, 1, 0));
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: GFLoader(
        type: GFLoaderType.circle,
      ),
    );
  }

  Future<DownloadMetadata> fetchFileMeta(
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
