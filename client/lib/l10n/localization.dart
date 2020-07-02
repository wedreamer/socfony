import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'generated/messages_all.dart';

part 'message/app.dart';
part 'message/navigation-bar.dart';

class AppLocalizations {
  /// Create l10n instance
  const AppLocalizations();

  static List<Locale> locales = [
    defaultLocale,
  ];

  static Locale get defaultLocale => Locale('zh', 'CN');

  /// Start loading the resources for `locale`. The returned future completes
  /// when the resources have finished loading.
  ///
  /// It's assumed that the this method will return an object that contains
  /// a collection of related resources (typically defined with one method per
  /// resource). The object will be retrieved with [AppLocalizations.of].
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return const AppLocalizations();
    });
  }

  /// The [AppLocalizations] from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// This method is just a convenient shorthand for:
  /// `SNSMaxLocalizations.of(context)`.
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// FlatButton(onPressed: null, child: Text(SNSMaxLocalizations.of(context).cancel))
  /// ```
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// The `SNSMaxLocalizationsDelegate` form the [AppLocalizations] static
  /// getter instance.
  ///
  /// This method is just a convenient shorthand for:
  /// `AppLocalizations.delegate`.
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// MaterialApp(
  ///     localizationsDelegates: [
  ///       AppLocalizationsDelegate.delegate
  ///     ],
  /// );
  /// ```
  static AppLocalizationsDelegate get delegate =>
      const AppLocalizationsDelegate();

  /// app.* messages
  AppIntlMessages get app => const AppIntlMessages();

  /// navigationBar.* messages
  NavigationBarMessage get navigationBar => const NavigationBarMessage();
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Create the [AppLocalizationsDelegate] instance.
  const AppLocalizationsDelegate() : super();

  /// Whether resources for the given locale can be loaded by this delegate.
  ///
  /// Return true if the instance of `SNSMaxLocalizations` loaded by this delegate's [load]
  /// method supports the given `locale`'s language.
  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.locales.contains(locale);
  }

  /// Start loading the resources for `locale`. The returned future completes
  /// when the resources have finished loading.
  ///
  /// It's assumed that the this method will return an object that contains
  /// a collection of related resources (typically defined with one method per
  /// resource). The object will be retrieved with [Localizations.of].
  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  /// Returns true if the resources for this delegate should be loaded
  /// again by calling the [load] method.
  ///
  /// This method is called whenever its [Localizations] widget is
  /// rebuilt. If it returns true then dependent widgets will be rebuilt
  /// after [load] has completed.
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
