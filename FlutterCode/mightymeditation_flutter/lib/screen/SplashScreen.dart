import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:mighty_meditation/utils/images.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import 'ChooseInterest.dart';
import 'DashboardScreen.dart';
import 'GetStartedScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    await 2.seconds.delay;
    bool seen = (getBoolAsync(IS_FIRST_TIME,defaultValue: true));
    if (!seen) {
      if(getStringListAsync(chooseTopicList) != null&& getStringListAsync(chooseTopicList)!.isNotEmpty)
      {
        DashboardScreen().launch(context, isNewTask: true);
      }
      else{
        ChooseInterest().launch(context);
      }
    } else {
      await setValue(IS_FIRST_TIME, true);
      GetStartedScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ic_logo, height: 250, fit: BoxFit.cover),
          16.height,
          Text(AppName, style: boldTextStyle(size: 26)).center(),
        ],
      ).center(),
    );
  }
}
