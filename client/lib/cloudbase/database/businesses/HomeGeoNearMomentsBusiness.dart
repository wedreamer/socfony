import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:snsmax/cloudbase.dart';

class HomeGeoNearMomentsBusiness with ChangeNotifier {
  static HomeGeoNearMomentsBusiness _instance;

  Iterable<String> _ids;
  Iterable<String> get ids => _ids ?? [];

  HomeGeoNearMomentsBusiness._();

  factory HomeGeoNearMomentsBusiness() {
    if (_instance is! HomeGeoNearMomentsBusiness) {
      _instance = HomeGeoNearMomentsBusiness._();
    }

    return _instance;
  }

  bool get isEmpty => ids?.isEmpty ?? true;

  Future<Iterable<String>> _query(Position position, [int offset = 0]) async {
    final command = CloudBase().database.command;
    final geometry = Geo().point(position.longitude, position.latitude);
    final result = await CloudBase()
        .database
        .collection('moments')
        .where({
          'location': command.geoNear(
            geometry,
            maxDistance: 1000 * 100, // 100km
            minDistance: 0,
          ),
        })
        .limit(15)
        .skip(offset)
        .field({"_id": true})
        .get();

    return (result.data as List)?.map((e) => e['_id'] as String);
  }

  Future<int> refresh(Position position) async {
    _ids = await _query(position);

    notifyListeners();

    return ids.length;
  }

  Future<int> loadMore(Position position) async {
    final ids = await _query(position, this.ids?.length ?? 0);

    _ids = this.ids.toList()
      ..addAll(ids)
      ..toSet();

    notifyListeners();

    return ids.length;
  }
}
