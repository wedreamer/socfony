// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Vote> _$voteSerializer = new _$VoteSerializer();

class _$VoteSerializer implements StructuredSerializer<Vote> {
  @override
  final Iterable<Type> types = const [Vote, _$Vote];
  @override
  final String wireName = 'Vote';

  @override
  Iterable<Object> serialize(Serializers serializers, Vote object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.count != null) {
      result
        ..add('count')
        ..add(serializers.serialize(object.count,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Vote deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VoteBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'count':
          result.count = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Vote extends Vote {
  @override
  final String name;
  @override
  final int count;

  factory _$Vote([void Function(VoteBuilder) updates]) =>
      (new VoteBuilder()..update(updates)).build();

  _$Vote._({this.name, this.count}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Vote', 'name');
    }
  }

  @override
  Vote rebuild(void Function(VoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoteBuilder toBuilder() => new VoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Vote && name == other.name && count == other.count;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), count.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Vote')
          ..add('name', name)
          ..add('count', count))
        .toString();
  }
}

class VoteBuilder implements Builder<Vote, VoteBuilder> {
  _$Vote _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  VoteBuilder();

  VoteBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _count = _$v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Vote other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Vote;
  }

  @override
  void update(void Function(VoteBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Vote build() {
    final _$result = _$v ?? new _$Vote._(name: name, count: count);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
