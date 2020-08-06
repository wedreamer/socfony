import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'moment-like-history.g.dart';

abstract class MomentLikeHistory
    implements Built<MomentLikeHistory, MomentLikeHistoryBuilder> {
  @BuiltValueField(wireName: "_id")
  String get id;

  String get userId;
  String get momentId;

  DateTime get createdAt;

  MomentLikeHistory._();
  factory MomentLikeHistory([void Function(MomentLikeHistoryBuilder) updates]) =
      _$MomentLikeHistory;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MomentLikeHistory.serializer, this);
  }

  static MomentLikeHistory fromJson(Object json) {
    return serializers.deserializeWith(MomentLikeHistory.serializer, json);
  }

  static Serializer<MomentLikeHistory> get serializer =>
      _$momentLikeHistorySerializer;
}
