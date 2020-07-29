import 'package:flutter/material.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/provider/cached-network-file.dart';

import 'CloudBaseDocBuilder.dart';

class CloudBaseFileBuilder extends CloudBaseDocBuilder<String, DownloadMetadata,
    CachedNetworkFileProvider> {
  const CloudBaseFileBuilder({
    Key key,
    @required String fileId,
    @required CloudBaseDocChildBuilder<DownloadMetadata> builder,
    CloudBaseDocLoadingBuilder loadingBuilder,
    CloudBaseDocErrorBuilder errorBuilder,
  }) : super(
          key: key,
          id: fileId,
          builder: builder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        );
}
