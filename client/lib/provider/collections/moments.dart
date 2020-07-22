import 'package:snsmax/models/moment.dart';
import 'package:snsmax/provider/collection.dart';

class MomentsCollection extends BaseCollectionProvider<String, Moment> {
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
