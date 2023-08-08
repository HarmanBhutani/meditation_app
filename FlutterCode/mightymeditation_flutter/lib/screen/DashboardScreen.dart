import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/main.dart';
import 'package:mighty_meditation/screen/CategoryScreen.dart';
import 'package:mighty_meditation/screen/FavouriteScreen.dart';
import 'package:mighty_meditation/screen/HomeScreen.dart';
import 'package:mighty_meditation/screen/SearchScreen.dart';
import 'package:mighty_meditation/screen/SettingScreen.dart';
import 'package:mighty_meditation/screen/WebViewScreen.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:mighty_meditation/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import 'AudioDetailScreen.dart';
import 'NotificationScreen.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  DateTime? _currentBackPressTime;

  final tab = [
    HomeScreen(),
    CategoryScreen(),
    SearchScreen(),
    FavouriteScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (isMobile) {
      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) async {
        if (!notification.notification.launchUrl.isEmptyOrNull) {
          NotificationScreen(data:notification.notification).launch(context);
          // WebViewScreen(mInitialUrl: notification.notification.launchUrl,).launch(context);
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return WillPopScope(
        onWillPop: () {
          DateTime now = DateTime.now();

          if (_currentBackPressTime == null ||
              now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
            _currentBackPressTime = now;
            toast( 'Press back again to exit');

            return Future.value(false);
          }
          return Future.value(true);
        },

        child: Scaffold(
          body: tab[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: context.scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: primaryTextStyle(size: 12),
            currentIndex: _currentIndex,
            unselectedItemColor: unSelectIconColor,
            selectedItemColor: appStore.isDarkModeOn ? Colors.white : primaryColor,
            onTap: (index) {
              _currentIndex = index;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Feather.home), label: languages.lblHome),
              BottomNavigationBarItem(icon: Icon(Feather.package), label: languages.lblCategories),
              BottomNavigationBarItem(icon: Icon(Feather.search), label: languages.lblSearch),
              BottomNavigationBarItem(icon: Icon(Feather.star), label: languages.lblFavourite),
              BottomNavigationBarItem(icon: Icon(Feather.settings), label: languages.lblSetting),
            ],
          ),
        ),
      );
    });
  }
}
