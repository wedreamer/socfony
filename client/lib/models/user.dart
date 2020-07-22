import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:snsmax/models/serializers.dart';

part 'user.g.dart';

@BuiltValue(defaultCompare: false)
abstract class User implements Built<User, UserBuilder> {
  @BuiltValueField(wireName: "_id", compare: true)
  String get id;

  @nullable
  String get private;

  @nullable
  @BuiltValueField(serialize: false)
  DateTime get createdAt;

  @nullable
  String get uid;

  @nullable
  String get nickName;

  @nullable
  UserGender get gender;

  @nullable
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

@BuiltValue(defaultCompare: false)
abstract class UserPrivate implements Built<UserPrivate, UserPrivateBuilder> {
  @BuiltValueField(wireName: "_id", compare: true)
  String get id;

  @nullable
  String get phone;

  @nullable
  String get userId;

  UserPrivate._();
  factory UserPrivate([void Function(UserPrivateBuilder) updates]) =
      _$UserPrivate;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UserPrivate.serializer, this);
  }

  static UserPrivate fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UserPrivate.serializer, json);
  }

  static Serializer<UserPrivate> get serializer => _$userPrivateSerializer;
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
