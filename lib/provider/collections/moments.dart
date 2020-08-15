import 'package:fans/models/moment.dart';
import 'package:fans/provider/collection.dart';

class MomentsCollection extends BaseCollectionProvider<String, Moment> {
  static MomentsCollection _instance;

  factory MomentsCollection() {
    if (_instance == null) {
      _instance = MomentsCollection._();
    }
    return _instance;
  }

  MomentsCollection._();

  @override
  String toCollectionId(Moment value) => value.id;

  @override
  String toDocId(Moment value) => toCollectionId(value);

  @override
  String get collectionName => "moments";

  @override
  Moment formObject(Object value) {
    return super.formObject(value) ?? Moment.fromJson(value);
  }
}
