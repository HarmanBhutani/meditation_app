import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/screen/ChooseInterest.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:mighty_meditation/utils/colors.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../component/SettingItemWidget.dart';
import '../component/ThemeSelectionDialog.dart';
import '../main.dart';
import '../model/LanguageDataModel.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import 'AboutUsScreen.dart';
import 'WebViewScreen.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBar(languages.lblSetting.validate()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadowWidget(spreadRadius: 0, borderRadius: radius(12), backgroundColor: context.cardColor),
                child: Column(
                  children: [
                    SettingItemWidget(
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      title: languages.lblChooseInterest,
                      width: context.width(),
                      leading: Icon(MaterialCommunityIcons.view_grid_plus_outline, color: textPrimaryColorGlobal),
                      onTap: () {
                        ChooseInterest(isSetting: true).launch(context);
                      },
                    ),
                    Divider(color: viewLineColor),
                    SettingItemWidget(
                        titleTextStyle: primaryTextStyle(),
                        padding: EdgeInsets.all(8),
                        title: languages.lblPushNotification,
                        width: context.width(),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: primaryColor,
                            value: appStore.isNotificationOn,
                            onChanged: (v) {
                              appStore.setNotification(v);
                              setState(() {});
                            },
                          ).withHeight(10),
                        ),
                        leading: Icon(MaterialIcons.notifications_none, color: textPrimaryColorGlobal),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (_) => ThemeSelectionDialog(),
                          );
                        }),
                    Divider(color: viewLineColor),
                    SettingItemWidget(
                        titleTextStyle: primaryTextStyle(),
                        padding: EdgeInsets.all(8),
                        title: languages.lblSelectTheme,
                        width: context.width(),
                        leading: Icon(MaterialCommunityIcons.theme_light_dark, color: textPrimaryColorGlobal),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (_) => ThemeSelectionDialog(),
                          );
                        }),
                    Divider(color: viewLineColor),
                    SettingItemWidget(
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      title: languages.lblLanguage,
                      width: context.width(),
                      trailing: DropdownButton(
                        isDense: true,
                        isExpanded: true,
                        items: localeLanguageList.map((e) => DropdownMenuItem<LanguageDataModel>(child: Text(e.name.toString(), style: primaryTextStyle(size: 14)), value: e)).toList(),
                        dropdownColor: context.scaffoldBackgroundColor,
                        value: language,
                        underline: SizedBox(),
                        onChanged: (LanguageDataModel? v) async {
                          setValue(SELECTED_LANGUAGE_CODE, v!.languageCode.toString());
                          language = v;
                          appStore.setLanguage(v.languageCode!, context: context);
                          setState(() {});
                          finish(context, true);
                        },
                      ).expand(),
                      leading: Icon(Entypo.language, color: textPrimaryColorGlobal),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadowWidget(spreadRadius: 0, borderRadius: radius(12), backgroundColor: context.cardColor),
                child: Column(
                  children: [
                    SettingItemWidget(
                      title: languages.lblShare + " " + AppName,
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      leading: Icon(AntDesign.sharealt, color: textPrimaryColorGlobal),
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          Share.share('Share $AppName app\n$playStoreBaseURL${value.packageName}');
                        });
                      },
                    ),
                    Divider(color: viewLineColor),
                    SettingItemWidget(
                      title: languages.lblRateUs,
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      leading: Icon(FontAwesome.star_o, color: textPrimaryColorGlobal),
                      onTap: () {
                        PackageInfo.fromPlatform().then((value) {
                          String package = '';
                          if (isAndroid) package = value.packageName;
                          launchUrl(Uri.parse('${storeBaseURL()}$package'));
                        });
                      },
                    ),
                    Divider(color: viewLineColor).visible(getStringAsync(PRIVACY_POLICY_PREF).isNotEmpty),
                    SettingItemWidget(
                      title: languages.lblPrivacyPolicy,
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      leading: Icon(Ionicons.md_document_text_outline, color: textPrimaryColorGlobal),
                      onTap: () {
                        if (getStringAsync(PRIVACY_POLICY_PREF).isNotEmpty)
                          WebViewScreen(
                            mInitialUrl: getStringAsync(PRIVACY_POLICY_PREF),
                          ).launch(context);
                        else
                          toast(languages.lblUrlEmpty);
                      },
                    ).visible(!getStringAsync(PRIVACY_POLICY_PREF).isEmptyOrNull),
                    Divider(color: viewLineColor).visible(getStringAsync(TERMS_AND_CONDITION_PREF).isNotEmpty),
                    SettingItemWidget(
                      title: languages.lblTermsCondition,
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      leading: Icon(MaterialCommunityIcons.shield_check_outline, color: textPrimaryColorGlobal),
                      onTap: () async {
                        if (getStringAsync(TERMS_AND_CONDITION_PREF).isNotEmpty)
                          WebViewScreen(mInitialUrl: getStringAsync(TERMS_AND_CONDITION_PREF)).launch(context);
                        else
                          toast(languages.lblUrlEmpty);
                      },
                    ).visible(!getStringAsync(TERMS_AND_CONDITION_PREF).isEmptyOrNull),
                    Divider(color: viewLineColor),
                    SettingItemWidget(
                      title: languages.lblAboutUs,
                      titleTextStyle: primaryTextStyle(),
                      padding: EdgeInsets.all(8),
                      leading: Icon(MaterialIcons.info_outline, color: textPrimaryColorGlobal),
                      onTap: () {
                        hideKeyboard(context);
                        AboutUsScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
