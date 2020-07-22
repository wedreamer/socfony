import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/models/moment.dart';

class MomentsCollection with ChangeNotifier {
  Map<String, Moment> _moments = <String, Moment>{};

  Map<String, Moment> get moments => _moments;

  void set(List<Moment> moments) {
    if (moments is! List<Moment>) {
      return;
    }

    List<Moment> needPut = moments
        .where((element) => !this.moments.containsKey(element.id))
        .toList();

    _moments
        .addAll(needPut.asMap().map((_, value) => MapEntry(value.id, value)));

    notifyListeners();
    needPut.forEach((Moment element) {
      CloudBase().database.collection('moments').doc(element.id).watch(
        onChange: (Snapshot snapshot) {
          snapshot.docChanges.forEach((element) {
            Moment doc = Moment.fromJson(element.doc);
            if (this.moments.containsKey(doc.id)) {
              _moments.update(doc.id, (_) => doc);
            } else {
              _moments.addAll({doc.id: doc});
            }
          });
          notifyListeners();
        },
      );
    });
  }

  void remove(Moment moment) {
    _moments.remove(moment.id);
    notifyListeners();
  }

  void removeById(String id) {
    _moments.remove(id);
    notifyListeners();
  }

  Moment getById(String id) {
    return moments[id];
  }
}
