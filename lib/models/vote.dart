import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/serializers.dart';

part 'vote.g.dart';

abstract class Vote implements Built<Vote, VoteBuilder> {
  String get name;

  @nullable
  int get count;

  Vote._();
  factory Vote([void Function(VoteBuilder) updates]) = _$Vote;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Vote.serializer, this);
  }

  static Vote fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Vote.serializer, json);
  }

  static Serializer<Vote> get serializer => _$voteSerializer;
}
