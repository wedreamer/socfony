// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment-like-history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MomentLikeHistory> _$momentLikeHistorySerializer =
    new _$MomentLikeHistorySerializer();

class _$MomentLikeHistorySerializer
    implements StructuredSerializer<MomentLikeHistory> {
  @override
  final Iterable<Type> types = const [MomentLikeHistory, _$MomentLikeHistory];
  @override
  final String wireName = 'MomentLikeHistory';

  @override
  Iterable<Object> serialize(Serializers serializers, MomentLikeHistory object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'momentId',
      serializers.serialize(object.momentId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MomentLikeHistory deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MomentLikeHistoryBuilder();

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
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'momentId':
          result.momentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MomentLikeHistory extends MomentLikeHistory {
  @override
  final String id;
  @override
  final String userId;
  @override
  final String momentId;

  factory _$MomentLikeHistory(
          [void Function(MomentLikeHistoryBuilder) updates]) =>
      (new MomentLikeHistoryBuilder()..update(updates)).build();

  _$MomentLikeHistory._({this.id, this.userId, this.momentId}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('MomentLikeHistory', 'id');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('MomentLikeHistory', 'userId');
    }
    if (momentId == null) {
      throw new BuiltValueNullFieldError('MomentLikeHistory', 'momentId');
    }
  }

  @override
  MomentLikeHistory rebuild(void Function(MomentLikeHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MomentLikeHistoryBuilder toBuilder() =>
      new MomentLikeHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MomentLikeHistory &&
        id == other.id &&
        userId == other.userId &&
        momentId == other.momentId;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, id.hashCode), userId.hashCode), momentId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MomentLikeHistory')
          ..add('id', id)
          ..add('userId', userId)
          ..add('momentId', momentId))
        .toString();
  }
}

class MomentLikeHistoryBuilder
    implements Builder<MomentLikeHistory, MomentLikeHistoryBuilder> {
  _$MomentLikeHistory _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _momentId;
  String get momentId => _$this._momentId;
  set momentId(String momentId) => _$this._momentId = momentId;

  MomentLikeHistoryBuilder();

  MomentLikeHistoryBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _userId = _$v.userId;
      _momentId = _$v.momentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MomentLikeHistory other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MomentLikeHistory;
  }

  @override
  void update(void Function(MomentLikeHistoryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MomentLikeHistory build() {
    final _$result = _$v ??
        new _$MomentLikeHistory._(id: id, userId: userId, momentId: momentId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
