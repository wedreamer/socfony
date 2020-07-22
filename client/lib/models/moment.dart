import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/media.dart';
import 'package:snsmax/models/vote.dart';

import 'serializers.dart';

part 'moment.g.dart';

@BuiltValue(defaultCompare: false)
abstract class Moment implements Built<Moment, MomentBuilder> {
  @BuiltValueField(wireName: '_id', compare: true)
  String get id;

  @nullable
  String get text;

  String get userId;

  DateTime get createdAt;

  @nullable
  BuiltList<String> get images;

  @nullable
  MediaVideo get video;

  @nullable
  MediaAudio get audio;

  @nullable
  BuiltList<Vote> get vote;

  Moment._();
  factory Moment([void Function(MomentBuilder) updates]) = _$Moment;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Moment.serializer, this);
  }

  static Moment fromJson(Object json) {
    return serializers.deserializeWith(Moment.serializer, json);
  }

  static Serializer<Moment> get serializer => _$momentSerializer;
}
