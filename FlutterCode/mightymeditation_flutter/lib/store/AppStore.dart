import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../language/AppLocalizations.dart';
import '../language/BaseLanguage.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../model/LanguageDataModel.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isDarkModeOn = false;

  @observable
  bool isNotificationOn = false;

  @observable
  bool isPlay = false;

  @observable
  bool isLoading = false;

  @observable
  List<Category> playList = ObservableList<Category>();

  @action
  Future<void> clearPlayList() async {
    playList.clear();
  }

  @action
  void addPlayListItem(Category productList) {
    playList.add(productList);
  }

  @observable
  String selectedLanguageCode = "";

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkModeOn = aIsDarkMode;

    if (isDarkModeOn) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;
      defaultLoaderBgColorGlobal = Colors.black26;
      defaultLoaderAccentColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = primaryColor;
      shadowColorGlobal = Colors.black12;
    }
  }

  @action
  void setNotification(bool val) {
    isNotificationOn = val;
    setValue(IS_NOTIFICATION_ON, val);

    if (isMobile) {
      OneSignal.shared.disablePush(!val);
    }
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    language = getSelectedLanguageModel(defaultLanguage: aCode);
    selectedLanguageCode = getSelectedLanguageModel(defaultLanguage: defaultValues.defaultLanguage)!.languageCode!;

    if (context != null) languages = BaseLanguage.of(context)!;
    languages = await AppLocalizations().load(Locale(selectedLanguageCode));
  }

  @action
  void setPlay(bool val) => isPlay = val;

  @action
  void setLoading(bool val) => isLoading = val;
}
