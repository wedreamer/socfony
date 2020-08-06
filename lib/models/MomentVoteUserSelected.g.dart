// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MomentVoteUserSelected.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MomentVoteUserSelected> _$momentVoteUserSelectedSerializer =
    new _$MomentVoteUserSelectedSerializer();

class _$MomentVoteUserSelectedSerializer
    implements StructuredSerializer<MomentVoteUserSelected> {
  @override
  final Iterable<Type> types = const [
    MomentVoteUserSelected,
    _$MomentVoteUserSelected
  ];
  @override
  final String wireName = 'MomentVoteUserSelected';

  @override
  Iterable<Object> serialize(
      Serializers serializers, MomentVoteUserSelected object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'momentId',
      serializers.serialize(object.momentId,
          specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'vote',
      serializers.serialize(object.vote, specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  MomentVoteUserSelected deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MomentVoteUserSelectedBuilder();

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
        case 'momentId':
          result.momentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'vote':
          result.vote = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$MomentVoteUserSelected extends MomentVoteUserSelected {
  @override
  final String id;
  @override
  final String momentId;
  @override
  final String userId;
  @override
  final String vote;
  @override
  final DateTime createdAt;

  factory _$MomentVoteUserSelected(
          [void Function(MomentVoteUserSelectedBuilder) updates]) =>
      (new MomentVoteUserSelectedBuilder()..update(updates)).build();

  _$MomentVoteUserSelected._(
      {this.id, this.momentId, this.userId, this.vote, this.createdAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('MomentVoteUserSelected', 'id');
    }
    if (momentId == null) {
      throw new BuiltValueNullFieldError('MomentVoteUserSelected', 'momentId');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('MomentVoteUserSelected', 'userId');
    }
    if (vote == null) {
      throw new BuiltValueNullFieldError('MomentVoteUserSelected', 'vote');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('MomentVoteUserSelected', 'createdAt');
    }
  }

  @override
  MomentVoteUserSelected rebuild(
          void Function(MomentVoteUserSelectedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MomentVoteUserSelectedBuilder toBuilder() =>
      new MomentVoteUserSelectedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MomentVoteUserSelected &&
        id == other.id &&
        momentId == other.momentId &&
        userId == other.userId &&
        vote == other.vote &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), momentId.hashCode), userId.hashCode),
            vote.hashCode),
        createdAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MomentVoteUserSelected')
          ..add('id', id)
          ..add('momentId', momentId)
          ..add('userId', userId)
          ..add('vote', vote)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MomentVoteUserSelectedBuilder
    implements Builder<MomentVoteUserSelected, MomentVoteUserSelectedBuilder> {
  _$MomentVoteUserSelected _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _momentId;
  String get momentId => _$this._momentId;
  set momentId(String momentId) => _$this._momentId = momentId;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _vote;
  String get vote => _$this._vote;
  set vote(String vote) => _$this._vote = vote;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  MomentVoteUserSelectedBuilder();

  MomentVoteUserSelectedBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _momentId = _$v.momentId;
      _userId = _$v.userId;
      _vote = _$v.vote;
      _createdAt = _$v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MomentVoteUserSelected other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MomentVoteUserSelected;
  }

  @override
  void update(void Function(MomentVoteUserSelectedBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MomentVoteUserSelected build() {
    final _$result = _$v ??
        new _$MomentVoteUserSelected._(
            id: id,
            momentId: momentId,
            userId: userId,
            vote: vote,
            createdAt: createdAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
