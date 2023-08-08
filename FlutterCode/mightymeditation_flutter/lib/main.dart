import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_meditation/store/AppStore.dart';
import 'package:mighty_meditation/store/WishListStore/WishListStore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mighty_meditation/utils/Extensions/Commons.dart';
import 'package:mighty_meditation/utils/Extensions/Constants.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/device_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/shared_pref.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:mighty_meditation/utils/colors.dart';
import 'package:mighty_meditation/utils/common.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppTheme.dart';
import 'component/NoInternetScreen.dart';
import 'language/AppLocalizations.dart';
import 'language/BaseLanguage.dart';
import 'model/DashboardResponse.dart';
import 'model/LanguageDataModel.dart';
import 'screen/SplashScreen.dart';

AppStore appStore = AppStore();
WishListStore wishListStore = WishListStore();
late SharedPreferences sharedPreferences;

Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal = primaryColor;

int passwordLengthGlobal = 6;
int mAdShowCount = 0;
int mAdCategoryShowCount = 0;
int mAdDetailShowCount = 0;

bool isCurrentlyOnNoInternet = false;

List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? language;
late BaseLanguage languages;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initialize({
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  localeLanguageList = aLocaleLanguageList ?? [];
  language = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  String wishListString = getStringAsync(WISHLIST_ITEM_LIST);

  if (wishListString.isNotEmpty) {
    wishListStore.addAllWishListItem(jsonDecode(wishListString).map<Category>((e) => Category.fromJson(e)).toList());
  }
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(DEFAULT_LANGUAGE);

  if (isMobile) {
    await OneSignal.shared.setAppId(mOneSignalID);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _authStatus = 'Unknown';
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) async {
      if (e == ConnectivityResult.none) {
        log('not connected');
        push(NoInternetScreen());
      } else {
        pop();
        log('connected');
      }
    });
    if (Platform.isIOS) {
      initPlugin();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();

  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        title: AppName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode.validate(value: DEFAULT_LANGUAGE)),
      );
    });
  }

  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    if (status == TrackingStatus.notDetermined) {
      final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }
}
