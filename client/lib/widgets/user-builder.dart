import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/user.dart';
import 'package:provider/provider.dart';
import 'package:snsmax/provider/collections/users.dart';

typedef Widget UserChildBuilder(BuildContext context, User user);
typedef Widget UserChildLoadingErrorBuilder(
    BuildContext context, dynamic error);

Map<String, bool> _fetching = {};

class UserBuilder extends StatelessWidget {
  final UserChildBuilder builder;
  final WidgetBuilder loadingBuilder;
  final UserChildLoadingErrorBuilder errorBuilder;
  final String id;

  const UserBuilder({
    Key key,
    @required this.id,
    @required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  Future<User> _fetchUser(UsersCollection collection) async {
    _fetching[id] = true;
    DbQueryResponse result =
        await CloudBase().database.collection('users').doc(id).get();
    _fetching.remove(id);
    if (result.code != null) {
      throw ErrorDescription(result.message);
    }

    List<Object> _value = result.data as List;
    if (_value == null || _value.isEmpty) {
      throw ErrorDescription("无法查询用户信息");
    }

    collection.insertOrUpdate(_value);

    return collection[id];
  }

  @override
  Widget build(BuildContext context) {
    return context.select<UsersCollection, Widget>(
        (UsersCollection collection) => selectBuilder(context, collection));
  }

  Widget selectBuilder(BuildContext context, UsersCollection collection) {
    if (collection.containsKey(id)) {
      return builder(context, collection.collections[id]);
    } else if (_fetching.containsKey(id) && _fetching[id] == true) {
      return finalLoadingBuilder(context);
    }

    return FutureBuilder(
      builder: futureBuilder,
      future: _fetchUser(collection),
    );
  }

  Widget futureBuilder(BuildContext context, AsyncSnapshot<User> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return finalLoadingBuilder(context);
    } else if (snapshot.hasError) {
      return finalErrorBuilder(context, snapshot.error);
    }

    return builder(context, snapshot.data);
  }

  Widget finalErrorBuilder(BuildContext context, dynamic error) {
    if (errorBuilder is UserChildLoadingErrorBuilder) {
      return errorBuilder(context, error);
    }

    return SizedBox();
  }

  Widget finalLoadingBuilder(BuildContext context) {
    if (loadingBuilder is WidgetBuilder) {
      return loadingBuilder(context);
    }

    return SizedBox();
  }
}
