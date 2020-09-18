import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/utils/cache-managers/file-cache-manager.dart';
import 'package:fans/widgets/cloudbase/storage/TcbStorageImageFileBuilder.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String fileId;
  final Widget child;
  final double radius;
  final Color backgroundColor;

  const UserAvatarWidget({
    Key key,
    this.fileId,
    this.child,
    this.radius,
    this.backgroundColor,
  }) : super(key: key);

  bool get hasCloudFileId => RegExp(r'cloud://[^\s]*').hasMatch(fileId);

  int get size {
    int size = (radius * 4).toInt();
    return size > 480 ? 480 : size;
  }

  String get rule =>
      'imageMogr2/scrop/${size}x$size/cut/${size}x$size/format/yjpeg';

  @override
  Widget build(BuildContext context) {
    final defaultAvatarWidget =
        _avatarBuilder(context, AssetImage('assets/avatar.webp'));
    if (fileId == null || fileId.isEmpty) {
      return defaultAvatarWidget;
    } else if (hasCloudFileId) {
      return TcbStorageImageFileBuilder(
        fileId: fileId,
        rule: rule,
        builder: _avatarBuilder,
        progressIndicatorBuilder: (_, __, ___) => defaultAvatarWidget,
        errorBuilder: (_, __, ___) => defaultAvatarWidget,
      );
    }

    return CachedNetworkImage(
      imageUrl: fileId,
      placeholder: (_, __) => defaultAvatarWidget,
      progressIndicatorBuilder: (_, __, ___) => defaultAvatarWidget,
      errorWidget: (_, __, ___) => defaultAvatarWidget,
      imageBuilder: _avatarBuilder,
      cacheManager: FileCacheManager(),
    );
  }

  Widget _avatarBuilder(BuildContext context, ImageProvider image) {
    return CircleAvatar(
      backgroundImage: image,
      child: child,
      radius: radius,
      backgroundColor: backgroundColor,
    );
  }
}
