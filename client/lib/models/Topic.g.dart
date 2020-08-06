// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Topic.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TopicPostType _$VIDEO = const TopicPostType._('VIDEO');

TopicPostType _$topicPostTypeValueOf(String name) {
  switch (name) {
    case 'VIDEO':
      return _$VIDEO;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TopicPostType> _$topicPostTypeValues =
    new BuiltSet<TopicPostType>(const <TopicPostType>[
  _$VIDEO,
]);

Serializer<TopicPostType> _$topicPostTypeSerializer =
    new _$TopicPostTypeSerializer();

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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
