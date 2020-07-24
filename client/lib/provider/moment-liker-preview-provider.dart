import 'package:flutter/foundation.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/user.dart';
import 'package:snsmax/provider/collection.dart';

class MomentLikerPreviewModel with ChangeNotifier {
  static Map<String, MomentLikerPreviewModel> _instances = {};

  String _id;
  String get id => _id;

  List<User> _users;
  List<User> get users => _users;

  MomentLikerPreviewModel._(this._id, this._users);

  factory MomentLikerPreviewModel(String id, List<User> users) {
    if (_instances.containsKey(id)) {
      return _instances[id].._update(users);
    }

    return _instances.putIfAbsent(
        id, () => MomentLikerPreviewModel._(id, users));
  }

  void _update(List<User> users) {
    _users = users;
    notifyListeners();
  }
}

class MomentLikerPreviewProvider
    extends BaseCollectionProvider<String, MomentLikerPreviewModel> {
  @override
  String get collectionName => throw UnimplementedError();

  @override
  String toCollectionId(MomentLikerPreviewModel element) {
    return element.id;
  }

  @override
  String toDocId(MomentLikerPreviewModel element) {
    return element.id;
  }

  @override
  Map<CollectionProviderActions, Iterable<MomentLikerPreviewModel>>
      originInsertOrUpdate(Iterable<Object> elements) {
    elements.forEach(_validate);
    return super.originInsertOrUpdate(elements);
  }

  @override
  void watcher(Iterable<MomentLikerPreviewModel> elements) {
    final Command command = CloudBase().database.command;
    CloudBase()
        .database
        .collection('moment-liked-histories')
        .where({
          "momentId": command.into(elements.map((e) => e.id).toList()),
        })
        .orderBy('createdAt', 'desc')
        .limit(3)
        .watch(onChange: _onChange);
  }

  void _onChange(Snapshot snapshot) {
    print(snapshot.docChanges.map((e) => e.doc).length);
  }

  void _validate(Object value) {
    if (value is! String || value is! MomentLikerPreviewModel) {
      throw UnsupportedError("Unsupported elements");
    }
  }
}
