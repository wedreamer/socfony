import 'package:intl/intl.dart';

extension DiffForNow on DateTime {
  String get formNow {
    Duration duration = DateTime.now().difference(this);
    if (duration.inDays > 364) {
      return DateFormat.yMMMMd('zh_CN').format(this);
    } else if (duration.inDays >= 1 && duration.inDays <= 7) {
      return DateFormat.MMMd('zh_CN').add_Hm().format(this);
    } else if (duration.inDays <= 0) {
      if (duration.inSeconds < 60) {
        return "${duration.inSeconds}秒前";
      } else if (duration.inMinutes < 60) {
        return "${duration.inMinutes}分钟前";
      }

      return "${duration.inHours}小时前";
    }

    return DateFormat.E('zh_CN').add_jms().format(this);
  }
}
