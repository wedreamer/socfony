import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/user.dart';
import 'package:snsmax/provider/collection.dart';

class UsersCollection extends BaseCollectionProvider<String, User> {
  @override
  void watcher(Iterable<User> elements) {
    CloudBase().database.collection("users").where({
      "_id": CloudBase()
          .database
          .command
          .into(elements.map<String>((e) => e.id).toList())
    }).watch(
      onChange: _onChange,
    );
  }

  void _onChange(Snapshot snapshot) {
    Map<String, User> elements = snapshot.docChanges.asMap().map<String, User>(
        (_, value) => MapEntry(value.docId, User.fromJson(value.doc)));
    if (elements.isNotEmpty) {
      originInsertOrUpdate(elements);
      notifyListeners();
    }
  }
}
