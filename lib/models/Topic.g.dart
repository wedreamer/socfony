// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Topic.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TopicPostType _$any = const TopicPostType._('any');
const TopicPostType _$video = const TopicPostType._('video');
const TopicPostType _$audio = const TopicPostType._('audio');
const TopicPostType _$image = const TopicPostType._('image');
const TopicPostType _$text = const TopicPostType._('text');

TopicPostType _$topicPostTypeValueOf(String name) {
  switch (name) {
    case 'any':
      return _$any;
    case 'video':
      return _$video;
    case 'audio':
      return _$audio;
    case 'image':
      return _$image;
    case 'text':
      return _$text;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TopicPostType> _$topicPostTypeValues =
    new BuiltSet<TopicPostType>(const <TopicPostType>[
  _$any,
  _$video,
  _$audio,
  _$image,
  _$text,
]);

const TopicJoinType _$freely = const TopicJoinType._('freely');
const TopicJoinType _$examine = const TopicJoinType._('examine');

TopicJoinType _$topicJoinTypeValueOf(String name) {
  switch (name) {
    case 'freely':
      return _$freely;
    case 'examine':
      return _$examine;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TopicJoinType> _$topicJoinTypeValues =
    new BuiltSet<TopicJoinType>(const <TopicJoinType>[
  _$freely,
  _$examine,
]);

Serializer<TopicPostType> _$topicPostTypeSerializer =
    new _$TopicPostTypeSerializer();
Serializer<TopicJoinType> _$topicJoinTypeSerializer =
    new _$TopicJoinTypeSerializer();

class _$TopicPostTypeSerializer implements PrimitiveSerializer<TopicPostType> {
  @override
  final Iterable<Type> types = const <Type>[TopicPostType];
  @override
  final String wireName = 'TopicPostType';

  @override
  Object serialize(Serializers serializers, TopicPostType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TopicPostType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TopicPostType.valueOf(serialized as String);
}

class _$TopicJoinTypeSerializer implements PrimitiveSerializer<TopicJoinType> {
  @override
  final Iterable<Type> types = const <Type>[TopicJoinType];
  @override
  final String wireName = 'TopicJoinType';

  @override
  Object serialize(Serializers serializers, TopicJoinType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TopicJoinType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TopicJoinType.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
