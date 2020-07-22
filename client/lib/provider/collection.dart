import 'package:flutter/foundation.dart';

enum CollectionProviderActions {
  inserts,
  updates,
}

abstract class BaseCollectionProvider<K, V> with ChangeNotifier {
  Map<K, V> _collections = {};
  Map<K, V> get collections => _collections;

  bool containsKey(K key) => collections.containsKey(key);
  bool containsValue(V value) => collections.containsValue(value);

  List<K> get keys => collections.keys;
  List<V> get values => collections.values;

  Map<CollectionProviderActions, Map<K, V>> originInsertOrUpdate(
      Map<K, V> elements) {
    if (elements == null || elements.isEmpty) {
      return {};
    }

    Map<K, V> inserts = elements.keys
        .where((K element) => !collections.containsKey(element))
        .toList()
        .asMap()
        .map<K, V>((_, K element) => MapEntry(element, elements[element]));
    Map<K, V> updates = elements.keys
        .where((K element) => !collections.containsKey(element))
        .toList()
        .asMap()
        .map<K, V>((_, K element) => MapEntry(element, elements[element]));
    _collections.updateAll((key, value) {
      if (updates.containsKey(key)) {
        return updates[key];
      }
      return value;
    });
    _collections.addAll(inserts);

    return {
      CollectionProviderActions.inserts: inserts,
      CollectionProviderActions.updates: updates,
    };
  }

  void insertOrUpdate(Map<K, V> elements) {
    Map<CollectionProviderActions, Map<K, V>> origin =
        originInsertOrUpdate(elements);

    notifyListeners();

    Map<K, V> inserts = origin[CollectionProviderActions.inserts];
    if (inserts.isNotEmpty) {
      watcher(inserts.values);
    }
  }

  void watcher(Iterable<V> elements);
}
