import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:snsmax/models/media.dart';
import 'package:snsmax/models/moment-like-history.dart';
import 'package:snsmax/models/moment.dart';
import 'package:snsmax/models/user.dart';
import 'package:snsmax/models/vote.dart';

part 'serializers.g.dart';

class DateTimeSerializer extends Iso8601DateTimeSerializer {
  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized is DateTime) {
      return serialized.toUtc();
    } else if (serialized is List) {
      Iterator iterator = serialized.iterator;
      iterator.moveNext();
      if (iterator.current == "\$date") {
        iterator.moveNext();

        return DateTime.fromMicrosecondsSinceEpoch(
          int.parse(iterator.current.toString()) * 1000,
          isUtc: true,
        );
      }

      return DateTime.now();
    }

    return super
        .deserialize(serializers, serialized, specifiedType: specifiedType);
  }
}

@SerializersFor([
  Moment,
  MomentCount,
  MediaAudio,
  MediaVideo,
  MomentLikeHistory,
  User,
  UserPrivate,
  UserGender,
  Vote,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(DateTimeSerializer()))
    .build();
