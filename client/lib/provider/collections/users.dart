import 'package:snsmax/models/user.dart';
import 'package:snsmax/provider/collection.dart';

class UsersCollection extends BaseCollectionProvider<String, User> {
  @override
  User formObject(Object value) {
    return super.formObject(value) ?? User.fromJson(value);
  }

  @override
  String toCollectionId(User value) => value.id;

  @override
  String toDocId(User value) => toCollectionId(value);

  @override
  String get collectionName => "users";
}
