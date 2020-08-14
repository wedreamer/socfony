import 'package:snsmax/cloudbase/commands/user/QueryUserCommand.dart';
import 'package:snsmax/models/user.dart';
import 'package:snsmax/provider/collection.dart';

class UsersCollection extends BaseCollectionProvider<String, User> {
  static UsersCollection _instance;

  factory UsersCollection() {
    if (_instance == null) {
      _instance = UsersCollection._();
    }
    return _instance;
  }

  UsersCollection._();

  @override
  User formObject(Object value) {
    return super.formObject(value) ?? User.fromJson(value);
  }

  @override
  String toCollectionId(User value) => value.uid;

  @override
  String toDocId(User value) => toCollectionId(value);

  @override
  bool get usingCustomWatchDoc => true;

  @override
  Future<User> customWatchDoc(String key) {
    return QueryUserCommand(key).run();
  }

  @override
  void watcher(Iterable<User> elements) {}

  @override
  String get collectionName => throw UnimplementedError();
}
