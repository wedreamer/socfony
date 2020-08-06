import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/serializers.dart';

part 'media.g.dart';

abstract class MediaVideo implements Built<MediaVideo, MediaVideoBuilder> {
  String get cover;

  String get src;

  MediaVideo._();
  factory MediaVideo([void Function(MediaVideoBuilder) updates]) = _$MediaVideo;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MediaVideo.serializer, this);
  }

  static MediaVideo fromJson(Object json) {
    return serializers.deserializeWith(MediaVideo.serializer, json);
  }

  static Serializer<MediaVideo> get serializer => _$mediaVideoSerializer;
}

abstract class MediaAudio implements Built<MediaAudio, MediaAudioBuilder> {
  @nullable
  String get cover;

  String get src;

  MediaAudio._();
  factory MediaAudio([void Function(MediaAudioBuilder) updates]) = _$MediaAudio;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MediaAudio.serializer, this);
  }

  static MediaAudio fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MediaAudio.serializer, json);
  }

  static Serializer<MediaAudio> get serializer => _$mediaAudioSerializer;
}
