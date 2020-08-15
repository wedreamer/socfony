import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/serializers.dart';

part 'Topic.g.dart';

class TopicPostType extends EnumClass {
  static const TopicPostType any = _$any;
  static const TopicPostType video = _$video;
  static const TopicPostType audio = _$audio;
  static const TopicPostType image = _$image;
  static const TopicPostType text = _$text;

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

class TopicJoinType extends EnumClass {
  static const TopicJoinType freely = _$freely;

  static const TopicJoinType examine = _$examine;

  const TopicJoinType._(String name) : super(name);

  static BuiltSet<TopicJoinType> get values => _$topicJoinTypeValues;
  static TopicJoinType valueOf(String name) => _$topicJoinTypeValueOf(name);

  String serialize() {
    return serializers.serializeWith(TopicJoinType.serializer, this);
  }

  static TopicJoinType deserialize(String string) {
    return serializers.deserializeWith(TopicJoinType.serializer, string);
  }

  static Serializer<TopicJoinType> get serializer => _$topicJoinTypeSerializer;
}
