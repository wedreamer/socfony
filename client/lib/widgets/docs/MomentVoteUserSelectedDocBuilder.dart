import 'package:flutter/material.dart';
import 'package:snsmax/models/MomentVoteUserSelected.dart';
import 'package:snsmax/provider/MomentVoteHasSelectedProvider.dart';

import '../CloudBaseDocBuilder.dart';

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
