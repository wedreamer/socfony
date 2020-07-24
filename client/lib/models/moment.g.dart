// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Moment> _$momentSerializer = new _$MomentSerializer();
Serializer<MomentCount> _$momentCountSerializer = new _$MomentCountSerializer();

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
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
    ];
    if (object.text != null) {
      result
        ..add('text')
        ..add(serializers.serialize(object.text,
            specifiedType: const FullType(String)));
    }
    if (object.images != null) {
      result
        ..add('images')
        ..add(serializers.serialize(object.images,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.video != null) {
      result
        ..add('video')
        ..add(serializers.serialize(object.video,
            specifiedType: const FullType(MediaVideo)));
    }
    if (object.audio != null) {
      result
        ..add('audio')
        ..add(serializers.serialize(object.audio,
            specifiedType: const FullType(MediaAudio)));
    }
    if (object.vote != null) {
      result
        ..add('vote')
        ..add(serializers.serialize(object.vote,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Vote)])));
    }
    if (object.count != null) {
      result
        ..add('count')
        ..add(serializers.serialize(object.count,
            specifiedType: const FullType(MomentCount)));
    }
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
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'images':
          result.images.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'video':
          result.video.replace(serializers.deserialize(value,
              specifiedType: const FullType(MediaVideo)) as MediaVideo);
          break;
        case 'audio':
          result.audio.replace(serializers.deserialize(value,
              specifiedType: const FullType(MediaAudio)) as MediaAudio);
          break;
        case 'vote':
          result.vote.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Vote)]))
              as BuiltList<Object>);
          break;
        case 'count':
          result.count.replace(serializers.deserialize(value,
              specifiedType: const FullType(MomentCount)) as MomentCount);
          break;
      }
    }

    return result.build();
  }
}

class _$MomentCountSerializer implements StructuredSerializer<MomentCount> {
  @override
  final Iterable<Type> types = const [MomentCount, _$MomentCount];
  @override
  final String wireName = 'MomentCount';

  @override
  Iterable<Object> serialize(Serializers serializers, MomentCount object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.like != null) {
      result
        ..add('like')
        ..add(serializers.serialize(object.like,
            specifiedType: const FullType(int)));
    }
    if (object.comment != null) {
      result
        ..add('comment')
        ..add(serializers.serialize(object.comment,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  MomentCount deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MomentCountBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'like':
          result.like = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Moment extends Moment {
  @override
  final String id;
  @override
  final String text;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<String> images;
  @override
  final MediaVideo video;
  @override
  final MediaAudio audio;
  @override
  final BuiltList<Vote> vote;
  @override
  final MomentCount count;

  factory _$Moment([void Function(MomentBuilder) updates]) =>
      (new MomentBuilder()..update(updates)).build();

  _$Moment._(
      {this.id,
      this.text,
      this.userId,
      this.createdAt,
      this.images,
      this.video,
      this.audio,
      this.vote,
      this.count})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Moment', 'id');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('Moment', 'userId');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Moment', 'createdAt');
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
    return (newBuiltValueToStringHelper('Moment')
          ..add('id', id)
          ..add('text', text)
          ..add('userId', userId)
          ..add('createdAt', createdAt)
          ..add('images', images)
          ..add('video', video)
          ..add('audio', audio)
          ..add('vote', vote)
          ..add('count', count))
        .toString();
  }
}

class MomentBuilder implements Builder<Moment, MomentBuilder> {
  _$Moment _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String> _images;
  ListBuilder<String> get images =>
      _$this._images ??= new ListBuilder<String>();
  set images(ListBuilder<String> images) => _$this._images = images;

  MediaVideoBuilder _video;
  MediaVideoBuilder get video => _$this._video ??= new MediaVideoBuilder();
  set video(MediaVideoBuilder video) => _$this._video = video;

  MediaAudioBuilder _audio;
  MediaAudioBuilder get audio => _$this._audio ??= new MediaAudioBuilder();
  set audio(MediaAudioBuilder audio) => _$this._audio = audio;

  ListBuilder<Vote> _vote;
  ListBuilder<Vote> get vote => _$this._vote ??= new ListBuilder<Vote>();
  set vote(ListBuilder<Vote> vote) => _$this._vote = vote;

  MomentCountBuilder _count;
  MomentCountBuilder get count => _$this._count ??= new MomentCountBuilder();
  set count(MomentCountBuilder count) => _$this._count = count;

  MomentBuilder();

  MomentBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _text = _$v.text;
      _userId = _$v.userId;
      _createdAt = _$v.createdAt;
      _images = _$v.images?.toBuilder();
      _video = _$v.video?.toBuilder();
      _audio = _$v.audio?.toBuilder();
      _vote = _$v.vote?.toBuilder();
      _count = _$v.count?.toBuilder();
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
    _$Moment _$result;
    try {
      _$result = _$v ??
          new _$Moment._(
              id: id,
              text: text,
              userId: userId,
              createdAt: createdAt,
              images: _images?.build(),
              video: _video?.build(),
              audio: _audio?.build(),
              vote: _vote?.build(),
              count: _count?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'images';
        _images?.build();
        _$failedField = 'video';
        _video?.build();
        _$failedField = 'audio';
        _audio?.build();
        _$failedField = 'vote';
        _vote?.build();
        _$failedField = 'count';
        _count?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Moment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$MomentCount extends MomentCount {
  @override
  final int like;
  @override
  final int comment;

  factory _$MomentCount([void Function(MomentCountBuilder) updates]) =>
      (new MomentCountBuilder()..update(updates)).build();

  _$MomentCount._({this.like, this.comment}) : super._();

  @override
  MomentCount rebuild(void Function(MomentCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MomentCountBuilder toBuilder() => new MomentCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MomentCount &&
        like == other.like &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, like.hashCode), comment.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MomentCount')
          ..add('like', like)
          ..add('comment', comment))
        .toString();
  }
}

class MomentCountBuilder implements Builder<MomentCount, MomentCountBuilder> {
  _$MomentCount _$v;

  int _like;
  int get like => _$this._like;
  set like(int like) => _$this._like = like;

  int _comment;
  int get comment => _$this._comment;
  set comment(int comment) => _$this._comment = comment;

  MomentCountBuilder();

  MomentCountBuilder get _$this {
    if (_$v != null) {
      _like = _$v.like;
      _comment = _$v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MomentCount other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MomentCount;
  }

  @override
  void update(void Function(MomentCountBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MomentCount build() {
    final _$result = _$v ?? new _$MomentCount._(like: like, comment: comment);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
