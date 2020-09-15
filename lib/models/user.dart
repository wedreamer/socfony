import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:fans/models/BaseModel.dart';
import 'package:fans/models/serializers.dart';

part 'user.g.dart';

abstract class User with AbstractBaseModel implements Built<User, UserBuilder> {
  @override
  @BuiltValueField(wireName: 'uid')
  String get id;

  @nullable
  @BuiltValueField(serialize: false)
  DateTime get createdAt;

  @nullable
  String get nickName;

  @nullable
  UserGender get gender;

  @nullable
  @BuiltValueField(wireName: 'avatarUrl')
  String get avatar;

  User._();
  factory User([void Function(UserBuilder) updates]) = _$User;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(User.serializer, this);
  }

  static User fromJson(Object json) {
    return serializers.deserializeWith(User.serializer, json);
  }

  static Serializer<User> get serializer => _$userSerializer;
}

class UserGender extends EnumClass {
  static const UserGender MALE = _$MALE;
  static const UserGender FEMALE = _$FEMALE;
  static const UserGender UNKNOWN = _$UNKNOWN;

  const UserGender._(String name) : super(name);

  static BuiltSet<UserGender> get values => _$userGenderValues;
  static UserGender valueOf(String name) => _$userGenderValueOf(name);

  String serialize() {
    return serializers.serializeWith(UserGender.serializer, this);
  }

  static UserGender deserialize(String string) {
    return serializers.deserializeWith(UserGender.serializer, string);
  }

  static Serializer<UserGender> get serializer => _$userGenderSerializer;
}
