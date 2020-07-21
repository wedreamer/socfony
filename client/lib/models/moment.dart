import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'moment.g.dart';

abstract class Moment implements Built<Moment, MomentBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

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
