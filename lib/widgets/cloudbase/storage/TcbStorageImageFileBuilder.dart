import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/utils/cache-managers/file-cache-manager.dart';
import 'package:fans/widgets/cloudbase/storage/TcbStorageFileBuilder.dart';
import 'package:fans/cloudbase/storage/TcbStorageFileMockDbQuery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TcbStorageImageFileBuilder extends StatelessWidget {
  final String fileId;
  final ImageWidgetBuilder builder;
  final PlaceholderWidgetBuilder placeholder;
  final ProgressIndicatorBuilder progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder errorBuilder;
  final BoxFit fit;
  final double width;
  final double height;
  final String rule;

  const TcbStorageImageFileBuilder({
    Key key,
    @required this.fileId,
    this.builder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    this.fit,
    this.width,
    this.height,
    this.rule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TcbStorageFileBuilder(
      fileId: fileId,
      builder: widgetBuilder,
    );
  }

  Widget widgetBuilder(BuildContext context,
      AsyncSnapshot<TcbStorageFileMockDbQueryModel> snapshot) {
    // 如果状态为 done 并且数据为正确数据模型，进行正确数据构造
    if (snapshot.connectionState == ConnectionState.done &&
        snapshot.data is TcbStorageFileMockDbQueryModel) {
      String url = snapshot.data.uri.toString();
      if (rule is String && rule.isNotEmpty) {
        url += '?$rule}';
      }

      return CachedNetworkImage(
        cacheManager: FileCacheManager(),
        imageUrl: url,
        imageBuilder: builder,
        placeholder: placeholder,
        progressIndicatorBuilder: progressIndicatorBuilder,
        errorWidget: errorBuilder,
      );
      // 如果检查到错误，并且错误构造器存在，则执行并返回错误构造起结果
    } else if (snapshot.hasError && errorBuilder is LoadingErrorWidgetBuilder) {
      return errorBuilder(context, fileId, snapshot.error);

      // 如果为等待状态，并且进度构造器存在，则执行并返回进度构造器结果
    } else if (snapshot.connectionState == ConnectionState.waiting &&
        progressIndicatorBuilder is ProgressIndicatorBuilder) {
      return progressIndicatorBuilder(
        context,
        fileId,
        DownloadProgress(fileId, 0, 0),
      );

      // 如果主要构造器存在，则返回主要构造器
    } else if (placeholder is PlaceholderWidgetBuilder) {
      return placeholder(context, fileId);
    }

    // 以上条件都不满足，则返回一个空盒子元素
    return SizedBox.shrink();
  }
}
