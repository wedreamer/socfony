// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserGender _$MALE = const UserGender._('MALE');
const UserGender _$FEMALE = const UserGender._('FEMALE');
const UserGender _$UNKNOWN = const UserGender._('UNKNOWN');

UserGender _$userGenderValueOf(String name) {
  switch (name) {
    case 'MALE':
      return _$MALE;
    case 'FEMALE':
      return _$FEMALE;
    case 'UNKNOWN':
      return _$UNKNOWN;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UserGender> _$userGenderValues =
    new BuiltSet<UserGender>(const <UserGender>[
  _$MALE,
  _$FEMALE,
  _$UNKNOWN,
]);

Serializer<User> _$userSerializer = new _$UserSerializer();
Serializer<UserGender> _$userGenderSerializer = new _$UserGenderSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable<Object> serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'uid',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    if (object.nickName != null) {
      result
        ..add('nickName')
        ..add(serializers.serialize(object.nickName,
            specifiedType: const FullType(String)));
    }
    if (object.gender != null) {
      result
        ..add('gender')
        ..add(serializers.serialize(object.gender,
            specifiedType: const FullType(UserGender)));
    }
    if (object.avatar != null) {
      result
        ..add('avatarUrl')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'uid':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'nickName':
          result.nickName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gender':
          result.gender = serializers.deserialize(value,
              specifiedType: const FullType(UserGender)) as UserGender;
          break;
        case 'avatarUrl':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$UserGenderSerializer implements PrimitiveSerializer<UserGender> {
  @override
  final Iterable<Type> types = const <Type>[UserGender];
  @override
  final String wireName = 'UserGender';

  @override
  Object serialize(Serializers serializers, UserGender object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  UserGender deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserGender.valueOf(serialized as String);
}

class _$User extends User {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String nickName;
  @override
  final UserGender gender;
  @override
  final String avatar;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._({this.id, this.createdAt, this.nickName, this.gender, this.avatar})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('User', 'id');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        createdAt == other.createdAt &&
        nickName == other.nickName &&
        gender == other.gender &&
        avatar == other.avatar;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, id.hashCode), createdAt.hashCode),
                nickName.hashCode),
            gender.hashCode),
        avatar.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('nickName', nickName)
          ..add('gender', gender)
          ..add('avatar', avatar))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  String _nickName;
  String get nickName => _$this._nickName;
  set nickName(String nickName) => _$this._nickName = nickName;

  UserGender _gender;
  UserGender get gender => _$this._gender;
  set gender(UserGender gender) => _$this._gender = gender;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _createdAt = _$v.createdAt;
      _nickName = _$v.nickName;
      _gender = _$v.gender;
      _avatar = _$v.avatar;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    final _$result = _$v ??
        new _$User._(
            id: id,
            createdAt: createdAt,
            nickName: nickName,
            gender: gender,
            avatar: avatar);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
