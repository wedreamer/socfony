part of "../localization.dart";

class NavigationBarMessage {
  const NavigationBarMessage();

  String get moment => Intl.message('动态', name: 'NavigationBarMessage_moment');
  String get explore => Intl.message('发现', name: 'NavigationBarMessage_explore');
  String get notification => Intl.message('消息', name: 'NavigationBarMessage_notification');
  String get me => Intl.message('我的', name: 'NavigationBarMessage_me');
}
