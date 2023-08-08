import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblCategory;

  String get lblFavourite;

  String get lblPopularStation;

  String get lblSuggested;

  String get lblLatest;

  String get lblAboutUs;

  String get lblPrivacyPolicy;

  String get lblTermsCondition;

  String get lblNoDataFound;

  String get lblNoInternet;

  String get lblRateUs;

  String get lblShare;

  String get lblSelectTheme;

  String get lblLanguage;

  String get lblPushNotification;

  String get lblSetting;

  String get lblWalk1;

  String get lblWalk1Desc;

  String get lblWalk2;

  String get lblWalk2Desc;

  String get lblWalk3;

  String get lblWalk3Desc;

  String get lblGetStarted;

  String get lblSkip;

  String get lblNext;

  String get lblUrlEmpty;

  String get lblAudioNotAvailable;

  String get lblChooseInterest;

  String get lblRemove;

  String get lblRemoveFavourite;

  String get chooseInterestMsg;

  String get chooseInterestMsg1;

  String get lblCopyRight;

  String get lblConfirm;

  String get lblConfirmCategory;

  String get lblHome;

  String get lblCategories;

  String get lblSearch;

  String get lblSessions;
}
