// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Moment> _$momentSerializer = new _$MomentSerializer();

class _$MomentSerializer implements StructuredSerializer<Moment> {
  @override
  final Iterable<Type> types = const [Moment, _$Moment];
  @override
  final String wireName = 'Moment';

  @override
  Iterable<Object> serialize(Serializers serializers, Moment object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Moment deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MomentBuilder();

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
      }
    }

    return result.build();
  }
}

class _$Moment extends Moment {
  @override
  final String id;

  factory _$Moment([void Function(MomentBuilder) updates]) =>
      (new MomentBuilder()..update(updates)).build();

  _$Moment._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Moment', 'id');
    }
  }

  @override
  Moment rebuild(void Function(MomentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MomentBuilder toBuilder() => new MomentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Moment && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Moment')..add('id', id)).toString();
  }
}

class MomentBuilder implements Builder<Moment, MomentBuilder> {
  _$Moment _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  MomentBuilder();

  MomentBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Moment other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Moment;
  }

  @override
  void update(void Function(MomentBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Moment build() {
    final _$result = _$v ?? new _$Moment._(id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
