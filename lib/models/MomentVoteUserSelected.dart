import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'MomentVoteUserSelected.g.dart';

abstract class MomentVoteUserSelected
    implements Built<MomentVoteUserSelected, MomentVoteUserSelectedBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get momentId;

  String get userId;

  String get vote;

  DateTime get createdAt;

  MomentVoteUserSelected._();
  factory MomentVoteUserSelected(
          [void Function(MomentVoteUserSelectedBuilder) updates]) =
      _$MomentVoteUserSelected;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MomentVoteUserSelected.serializer, this);
  }

  static MomentVoteUserSelected fromJson(Object json) {
    return serializers.deserializeWith(MomentVoteUserSelected.serializer, json);
  }

  static Serializer<MomentVoteUserSelected> get serializer =>
      _$momentVoteUserSelectedSerializer;
}
