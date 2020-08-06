import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/serializers.dart';

part 'Topic.g.dart';

class TopicPostType extends EnumClass {
  static const TopicPostType VIDEO = _$VIDEO;

  const TopicPostType._(String name) : super(name);

  static BuiltSet<TopicPostType> get values => _$topicPostTypeValues;
  static TopicPostType valueOf(String name) => _$topicPostTypeValueOf(name);

  String serialize() {
    return serializers.serializeWith(TopicPostType.serializer, this);
  }

  static TopicPostType deserialize(String string) {
    return serializers.deserializeWith(TopicPostType.serializer, string);
  }

  static Serializer<TopicPostType> get serializer => _$topicPostTypeSerializer;
}
