import 'package:fl_clash/common/app_localizations.dart';

/// Thrown when subscription content is encrypted but password is missing or wrong
class SubscriptionEncryptedException implements Exception {
  const SubscriptionEncryptedException({this.passwordWrong = false});

  /// True when password was provided but decryption failed (wrong password)
  final bool passwordWrong;

  @override
  String toString() => passwordWrong
      ? currentAppLocalizations.subscriptionPasswordWrongTip
      : currentAppLocalizations.subscriptionLoginPassword;
}
