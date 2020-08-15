import 'package:flutter/material.dart';
import 'package:fans/models/MomentVoteUserSelected.dart';
import 'package:fans/provider/MomentVoteHasSelectedProvider.dart';

import 'CloudBaseDocBuilder.dart';

class MomentVoteUserSelectedDocBuilder extends CloudBaseDocBuilder<String,
    MomentVoteUserSelected, MomentVoteHasSelectedProvider> {
  const MomentVoteUserSelectedDocBuilder({
    Key key,
    @required String id,
    @required CloudBaseDocChildBuilder<MomentVoteUserSelected> builder,
    CloudBaseDocLoadingBuilder loadingBuilder,
    CloudBaseDocErrorBuilder errorBuilder,
  }) : super(
          key: key,
          id: id,
          builder: builder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        );
}
