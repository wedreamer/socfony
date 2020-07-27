import 'package:intl/intl.dart' as intl;

extension NumberFormat on num {
  String format(String pattern) {
    return intl.NumberFormat(pattern).format(this);
  }

  String get compact {
    return intl.NumberFormat.compact().format(this);
  }
}
