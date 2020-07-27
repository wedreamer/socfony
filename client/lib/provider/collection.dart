import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:snsmax/cloudbase.dart';

/// 用户集合处理结果 keys 值枚举
///
/// 专门用于处理原始集合后返回处理结果
enum CollectionProviderActions {
  /// 插入的数据集合
  inserts,

  /// 更新的数据集合
  updates,
}

/// 数据集合基类，专门用于处理数据集合中通用部分
abstract class BaseCollectionProvider<K, V> with ChangeNotifier {
  /// 存储数据集合原始数据信息
  /// 以键值对形式存储私有的 [_collections] 中，类型为 `Map<K, V>` 形式存储
  Map<K, V> _collections = {};

  /// 只读形式获取 [_collections] 信息
  Map<K, V> get collections => _collections;

  /// 获取一个 [String] 类型的集合名称，主要用于 [watcher] 进行使用.
  ///
  /// 使用的时候需要再子类中定义 [collectionName] 的 getter.
  String get collectionName;

  /// Returns true if this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(K key) => collections.containsKey(key);

  /// Returns true if this map contains the given [value].
  bool containsValue(V value) => collections.containsValue(value);

  /// 获取当前对象的 `key` 集合
  Iterable<K> get keys => collections.keys;

  /// 获取当前对象的 `value` 集合
  Iterable<V> get values => collections.values;

  /// 原始好信息处理，处理完成后将返回以 `Map<CollectionProviderActions, Iterable<V>>`
  ///  为基准的原始信息。
  ///
  /// 其中 [CollectionProviderActions.inserts] 用于记录插入多少新文档；
  /// 而 [CollectionProviderActions.updates] 用于记录更新了多少文档；
  ///
  /// 返回信息如下:
  /// ```dart
  /// {
  ///   CollectionProviderActions.inserts: <V>[...],
  ///   CollectionProviderActions.updates: <V>[...],
  /// }
  /// ```
  ///
  /// 注意，传入的参数 [elements] 可以是 `Iterable<V>` 和 `Iterable<Object>`
  /// 或者 `Iterable<dynamic>`；程序判断出是 [V] 类型数据则直接跳过，其他情况均
  /// 调用 [formObject] 函数进行数据处理。
  Map<CollectionProviderActions, Iterable<V>> originInsertOrUpdate(
      Iterable<Object> elements) {
    /// 如果文档集合不存在，则直接返回空信息
    if (elements == null || elements.isEmpty) {
      return {
        CollectionProviderActions.inserts: [],
        CollectionProviderActions.updates: [],
      };
    }

    /// 将 [elements] 转化为 `Iterable<V>` 数据。
    Iterable<V> objects =
        elements.where((element) => element is! V).map<V>(formObject).toList()
          ..addAll(elements.whereType<V>())
          ..removeWhere((element) => element == null);

    /// 获取需要插入的数据集合
    final Map<K, V> inserts = objects
        .where((element) => !collections.containsKey(toCollectionId(element)))
        .toList()
        .asMap()
        .map<K, V>(
            (_, V element) => MapEntry(toCollectionId(element), element));

    /// 获取需要更新的数据集合
    final Map<K, V> updates = objects
        .where((V element) => !inserts.containsKey(toCollectionId(element)))
        .toList()
        .asMap()
        .map<K, V>(
            (_, V element) => MapEntry(toCollectionId(element), element));

    /// 将更新的数据集合放入 [collections] 中
    _collections.updateAll((key, value) {
      if (updates.containsKey(key)) {
        return updates[key];
      }
      return value;
    });

    /// 将需要插入的数据插入到 [collections] 中。
    _collections.addAll(inserts);

    /// 返回处理皇后的元信息
    return {
      CollectionProviderActions.inserts: inserts.values,
      CollectionProviderActions.updates: updates.values,
    };
  }

  /// 插入或者更新指定的数据集合，其方法参考 [originInsertOrUpdate] 函
  /// 数，其区别在于 [insertOrUpdate] 不返回任何结果信息，并且给插入的数
  /// 据集合设置一个 [CloudBase] 的数据 [watcher] 来保证服务端数据更改。
  Map<CollectionProviderActions, Iterable<V>> insertOrUpdate(
      Iterable<Object> elements) {
    final Map<CollectionProviderActions, Iterable<V>> state =
        originInsertOrUpdate(elements);

    notifyListeners();

    Iterable<V> inserts = state[CollectionProviderActions.inserts];
    if (inserts != null && inserts.isNotEmpty) {
      watcher(inserts);
    }

    return state;
  }

  /// 设置指定数据的监听。
  ///
  /// [elements] 是需要监听的数据集合
  void watcher(Iterable<V> elements) {
    CloudBase().database.collection(collectionName).where({
      "_id": CloudBase()
          .database
          .command
          .into(elements.map<String>((e) => toDocId(e)).toList())
    }).watch(
      onChange: _onChange,
    );
  }

  /// 数据监听回调
  void _onChange(Snapshot snapshot) {
    Iterable<Object> elements = snapshot.docChanges
        .where((element) => element.dataType == "update")
        .map((e) => e.doc);

    if (elements.isNotEmpty) {
      originInsertOrUpdate(elements);
      notifyListeners();
    }
  }

  /// 转换 [element] 为数据监听者所需的 ID
  String toDocId(V element);

  /// 转换 [element] 为集合存储所需要的 [K] 值
  K toCollectionId(V element);

  @mustCallSuper
  V formObject(Object value) {
    if (value is V) {
      return value;
    }

    return null;
  }

  void clear() {
    _collections.clear();
    notifyListeners();
  }

  V remove(String key) {
    final result = _collections.remove(key);
    notifyListeners();

    return result;
  }

  /// 便捷从集合中使用 [key] 获取文档
  V operator [](K key) => collections[key];

  /// 用于便捷的设置单个文档的更新
  void operator []=(K key, V value) => insertOrUpdate([value]);
}
