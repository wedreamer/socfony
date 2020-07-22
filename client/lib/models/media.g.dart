// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MediaVideo> _$mediaVideoSerializer = new _$MediaVideoSerializer();
Serializer<MediaAudio> _$mediaAudioSerializer = new _$MediaAudioSerializer();

class _$MediaVideoSerializer implements StructuredSerializer<MediaVideo> {
  @override
  final Iterable<Type> types = const [MediaVideo, _$MediaVideo];
  @override
  final String wireName = 'MediaVideo';

  @override
  Iterable<Object> serialize(Serializers serializers, MediaVideo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'cover',
      serializers.serialize(object.cover,
          specifiedType: const FullType(String)),
      'src',
      serializers.serialize(object.src, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MediaVideo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MediaVideoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'src':
          result.src = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MediaAudioSerializer implements StructuredSerializer<MediaAudio> {
  @override
  final Iterable<Type> types = const [MediaAudio, _$MediaAudio];
  @override
  final String wireName = 'MediaAudio';

  @override
  Iterable<Object> serialize(Serializers serializers, MediaAudio object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'src',
      serializers.serialize(object.src, specifiedType: const FullType(String)),
    ];
    if (object.cover != null) {
      result
        ..add('cover')
        ..add(serializers.serialize(object.cover,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  MediaAudio deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MediaAudioBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'src':
          result.src = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MediaVideo extends MediaVideo {
  @override
  final String cover;
  @override
  final String src;

  factory _$MediaVideo([void Function(MediaVideoBuilder) updates]) =>
      (new MediaVideoBuilder()..update(updates)).build();

  _$MediaVideo._({this.cover, this.src}) : super._() {
    if (cover == null) {
      throw new BuiltValueNullFieldError('MediaVideo', 'cover');
    }
    if (src == null) {
      throw new BuiltValueNullFieldError('MediaVideo', 'src');
    }
  }

  @override
  MediaVideo rebuild(void Function(MediaVideoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaVideoBuilder toBuilder() => new MediaVideoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaVideo && cover == other.cover && src == other.src;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, cover.hashCode), src.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MediaVideo')
          ..add('cover', cover)
          ..add('src', src))
        .toString();
  }
}

class MediaVideoBuilder implements Builder<MediaVideo, MediaVideoBuilder> {
  _$MediaVideo _$v;

  String _cover;
  String get cover => _$this._cover;
  set cover(String cover) => _$this._cover = cover;

  String _src;
  String get src => _$this._src;
  set src(String src) => _$this._src = src;

  MediaVideoBuilder();

  MediaVideoBuilder get _$this {
    if (_$v != null) {
      _cover = _$v.cover;
      _src = _$v.src;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaVideo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MediaVideo;
  }

  @override
  void update(void Function(MediaVideoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MediaVideo build() {
    final _$result = _$v ?? new _$MediaVideo._(cover: cover, src: src);
    replace(_$result);
    return _$result;
  }
}

class _$MediaAudio extends MediaAudio {
  @override
  final String cover;
  @override
  final String src;

  factory _$MediaAudio([void Function(MediaAudioBuilder) updates]) =>
      (new MediaAudioBuilder()..update(updates)).build();

  _$MediaAudio._({this.cover, this.src}) : super._() {
    if (src == null) {
      throw new BuiltValueNullFieldError('MediaAudio', 'src');
    }
  }

  @override
  MediaAudio rebuild(void Function(MediaAudioBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaAudioBuilder toBuilder() => new MediaAudioBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaAudio && cover == other.cover && src == other.src;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, cover.hashCode), src.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MediaAudio')
          ..add('cover', cover)
          ..add('src', src))
        .toString();
  }
}

class MediaAudioBuilder implements Builder<MediaAudio, MediaAudioBuilder> {
  _$MediaAudio _$v;

  String _cover;
  String get cover => _$this._cover;
  set cover(String cover) => _$this._cover = cover;

  String _src;
  String get src => _$this._src;
  set src(String src) => _$this._src = src;

  MediaAudioBuilder();

  MediaAudioBuilder get _$this {
    if (_$v != null) {
      _cover = _$v.cover;
      _src = _$v.src;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaAudio other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MediaAudio;
  }

  @override
  void update(void Function(MediaAudioBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MediaAudio build() {
    final _$result = _$v ?? new _$MediaAudio._(cover: cover, src: src);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
