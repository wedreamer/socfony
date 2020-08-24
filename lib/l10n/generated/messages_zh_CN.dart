// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "AppIntlMessages_name": MessageLookupByLibrary.simpleMessage("Fans"),
        "NavigationBarMessage_explore":
            MessageLookupByLibrary.simpleMessage("发现"),
        "NavigationBarMessage_me": MessageLookupByLibrary.simpleMessage("我的"),
        "NavigationBarMessage_moment":
            MessageLookupByLibrary.simpleMessage("动态"),
        "NavigationBarMessage_notification":
            MessageLookupByLibrary.simpleMessage("消息")
      };
}
