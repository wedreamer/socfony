import 'package:flutter/material.dart';
import 'package:fans/models/user.dart';
import 'package:fans/provider/collections/users.dart';
import 'package:fans/widgets/docs/CloudBaseDocBuilder.dart';

class UserDocBuilder
    extends CloudBaseDocBuilder<String, User, UsersCollection> {
  const UserDocBuilder({
    Key key,
    @required String id,
    @required CloudBaseDocChildBuilder<User> builder,
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
