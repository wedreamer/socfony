// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TopicCategory.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TopicCategory> _$topicCategorySerializer =
    new _$TopicCategorySerializer();

class _$TopicCategorySerializer implements StructuredSerializer<TopicCategory> {
  @override
  final Iterable<Type> types = const [TopicCategory, _$TopicCategory];
  @override
  final String wireName = 'TopicCategory';

  @override
  Iterable<Object> serialize(Serializers serializers, TopicCategory object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'order',
      serializers.serialize(object.order, specifiedType: const FullType(num)),
    ];

    return result;
  }

  @override
  TopicCategory deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TopicCategoryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'order':
          result.order = serializers.deserialize(value,
              specifiedType: const FullType(num)) as num;
          break;
      }
    }

    return result.build();
  }
}

class _$TopicCategory extends TopicCategory {
  @override
  final String id;
  @override
  final String name;
  @override
  final num order;

  factory _$TopicCategory([void Function(TopicCategoryBuilder) updates]) =>
      (new TopicCategoryBuilder()..update(updates)).build();

  _$TopicCategory._({this.id, this.name, this.order}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TopicCategory', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('TopicCategory', 'name');
    }
    if (order == null) {
      throw new BuiltValueNullFieldError('TopicCategory', 'order');
    }
  }

  @override
  TopicCategory rebuild(void Function(TopicCategoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TopicCategoryBuilder toBuilder() => new TopicCategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TopicCategory && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TopicCategory')
          ..add('id', id)
          ..add('name', name)
          ..add('order', order))
        .toString();
  }
}

class TopicCategoryBuilder
    implements Builder<TopicCategory, TopicCategoryBuilder> {
  _$TopicCategory _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  num _order;
  num get order => _$this._order;
  set order(num order) => _$this._order = order;

  TopicCategoryBuilder();

  TopicCategoryBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _order = _$v.order;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TopicCategory other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TopicCategory;
  }

  @override
  void update(void Function(TopicCategoryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TopicCategory build() {
    final _$result =
        _$v ?? new _$TopicCategory._(id: id, name: name, order: order);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
