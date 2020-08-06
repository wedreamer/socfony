import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'TopicCategory.g.dart';

abstract class TopicCategory
    implements Built<TopicCategory, TopicCategoryBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get name;

  @BuiltValueField(compare: false)
  num get order;

  TopicCategory._();
  factory TopicCategory([void Function(TopicCategoryBuilder) updates]) =
      _$TopicCategory;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(TopicCategory.serializer, this);
  }

  static TopicCategory fromJson(Object json) {
    return serializers.deserializeWith(TopicCategory.serializer, json);
  }

  static Serializer<TopicCategory> get serializer => _$topicCategorySerializer;
}
