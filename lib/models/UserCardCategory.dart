import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'UserCardCategory.g.dart';

abstract class UserCardCategory
    implements Built<UserCardCategory, UserCardCategoryBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get name;

  UserCardCategory._();
  factory UserCardCategory([void Function(UserCardCategoryBuilder) updates]) =
      _$UserCardCategory;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UserCardCategory.serializer, this);
  }

  static UserCardCategory fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UserCardCategory.serializer, json);
  }

  static Serializer<UserCardCategory> get serializer =>
      _$userCardCategorySerializer;
}
