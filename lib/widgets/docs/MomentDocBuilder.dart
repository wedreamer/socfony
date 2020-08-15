import 'package:flutter/material.dart';
import 'package:fans/models/moment.dart';
import 'package:fans/provider/collections/moments.dart';
import 'package:fans/widgets/docs/CloudBaseDocBuilder.dart';

class MomentDocBuilder
    extends CloudBaseDocBuilder<String, Moment, MomentsCollection> {
  const MomentDocBuilder({
    Key key,
    @required String id,
    @required CloudBaseDocChildBuilder<Moment> builder,
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
