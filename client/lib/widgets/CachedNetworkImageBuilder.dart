import 'package:cached_network_image/cached_network_image.dart' as cache;
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/utils/cache-managers/file-cache-manager.dart';

import 'CloudBaseDocBuilder.dart';
import 'CloudBaseFileBuilder.dart';

typedef ProgressIndicatorBuilder = Widget Function(
    BuildContext, DownloadProgress);
typedef PlaceholderWidgetBuilder = Widget Function(BuildContext);
typedef CachedNetworkImageChildBuilder(
    BuildContext context, ImageProvider image);

class _Payload {
  final String rule;
  final PlaceholderWidgetBuilder placeholderBuilder;
  final ProgressIndicatorBuilder progressIndicatorBuilder;
  final cache.ImageWidgetBuilder builder;
  final CloudBaseDocErrorBuilder errorBuilder;
  final BoxFit fit;
  final double width;
  final double height;

  const _Payload({
    this.rule,
    this.placeholderBuilder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    @required this.builder,
    this.fit,
    this.width,
    this.height,
  });

  toUrl(String url) {
    if (rule != null && rule.isNotEmpty) {
      return url + '?' + rule;
    }

    return url;
  }
}

cache.PlaceholderWidgetBuilder _placeholderBuilderBuilder(
    PlaceholderWidgetBuilder placeholderBuilder) {
  if (placeholderBuilder is PlaceholderWidgetBuilder) {
    return (BuildContext context, _) => placeholderBuilder(context);
  }
  return null;
}

cache.ProgressIndicatorBuilder _progressIndicatorBuilder(
    ProgressIndicatorBuilder progressIndicatorBuilder) {
  if (progressIndicatorBuilder is ProgressIndicatorBuilder) {
    return (BuildContext context, _, DownloadProgress progress) =>
        progressIndicatorBuilder(context, progress);
  }

  return (BuildContext context, _, __) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: GFLoader(
          type: GFLoaderType.circle,
        ),
      );
}

cache.LoadingErrorWidgetBuilder _errorWidgetBuilder(
    CloudBaseDocErrorBuilder errorBuilder) {
  if (errorBuilder is CloudBaseDocErrorBuilder) {
    return (BuildContext context, _, Object error) =>
        errorBuilder(context, error);
  }

  return (BuildContext context, __, ___) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Icon(
          Icons.broken_image,
          color: Theme.of(context).disabledColor,
        ),
      );
}

CloudBaseDocChildBuilder<DownloadMetadata> _widgetBuilder(_Payload payload) =>
    (BuildContext context, DownloadMetadata meta) {
      return cache.CachedNetworkImage(
        imageUrl: payload.toUrl(meta.downloadUrl),
        placeholder: _placeholderBuilderBuilder(payload.placeholderBuilder),
        progressIndicatorBuilder:
            _progressIndicatorBuilder(payload.progressIndicatorBuilder),
        errorWidget: _errorWidgetBuilder(payload.errorBuilder),
        imageBuilder: payload.builder,
        width: payload.width,
        height: payload.height,
        fit: payload.fit,
        cacheManager: FileCacheManager(),
      );
    };

CloudBaseDocLoadingBuilder _loadingBuilder(
    ProgressIndicatorBuilder progressIndicatorBuilder) {
  return progressIndicatorBuilder is cache.ProgressIndicatorBuilder
      ? (BuildContext context) =>
          progressIndicatorBuilder(context, DownloadProgress(null, 1, 0))
      : null;
}

class CachedNetworkImageBuilder extends CloudBaseFileBuilder {
  CachedNetworkImageBuilder({
    Key key,
    @required String fileId,
    String rule,
    PlaceholderWidgetBuilder placeholderBuilder,
    ProgressIndicatorBuilder progressIndicatorBuilder,
    cache.ImageWidgetBuilder builder,
    CloudBaseDocErrorBuilder errorBuilder,
    BoxFit fit,
    double width,
    double height,
  }) : super(
          key: key,
          fileId: fileId,
          builder: _widgetBuilder(
            _Payload(
              rule: rule,
              placeholderBuilder: placeholderBuilder,
              progressIndicatorBuilder: progressIndicatorBuilder,
              fit: fit,
              width: width,
              height: height,
              builder: builder,
              errorBuilder: errorBuilder,
            ),
          ),
          loadingBuilder: _loadingBuilder(progressIndicatorBuilder),
          errorBuilder: errorBuilder,
        );
}
