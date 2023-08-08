import 'package:flutter/material.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';
import '../utils/images.dart';
import 'WebViewScreen.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(languages.lblAboutUs, showBack: true),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    var whatsappUrl = "whatsapp://send?phone=${getStringAsync(WHATSAPP)}";
                    launchUrl(Uri.parse(whatsappUrl));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_whatsApp, height: 35, width: 35),
                  ),
                ).visible(!getStringAsync(WHATSAPP).isEmptyOrNull),
                InkWell(
                  onTap: () {
                    if (getStringAsync(INSTAGRAM).isNotEmpty) {
                      launchUrl(Uri.parse(getStringAsync(INSTAGRAM)));
                    } else {
                      toast(languages.lblUrlEmpty);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_insta, height: 35, width: 35),
                  ),
                ).visible(!getStringAsync(INSTAGRAM).isEmptyOrNull),
                InkWell(
                  onTap: () {
                    if (getStringAsync(TWITTER).isNotEmpty) {
                      WebViewScreen(mInitialUrl: getStringAsync(TWITTER)).launch(context);
                    } else {
                      toast(languages.lblUrlEmpty);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_twitter, height: 35, width: 35),
                  ),
                ).visible(!getStringAsync(TWITTER).isEmptyOrNull),
                InkWell(
                  onTap: () {
                    if (getStringAsync(FACEBOOK).isNotEmpty) {
                      WebViewScreen(
                        mInitialUrl: getStringAsync(FACEBOOK),
                      ).launch(context);
                    } else {
                      toast(languages.lblUrlEmpty);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_facebook, height: 35, width: 35),
                  ),
                ).visible(!getStringAsync(FACEBOOK).isEmptyOrNull),
                InkWell(
                  onTap: () {
                    if (getStringAsync(CONTACT_PREF).isNotEmpty) {
                      launchUrl(Uri.parse(('tel://${getStringAsync(CONTACT_PREF).validate()}')));
                    } else {
                      toast(languages.lblUrlEmpty);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.call, color: appStore.isDarkModeOn ? Colors.white : primaryColor, size: 36),
                  ),
                ).visible(!getStringAsync(CONTACT_PREF).isEmptyOrNull)
              ],
            ),
            8.height,
            getStringAsync(COPYRIGHT).isNotEmpty
                ? Text(getStringAsync(COPYRIGHT), style: secondaryTextStyle(letterSpacing: 1.2), maxLines: 1)
                : Text(languages.lblCopyRight + " @${DateTime.now().year} ${getStringAsync(COPYRIGHT)}", style: secondaryTextStyle(letterSpacing: 1.2)),
            8.height,
          ],
        ),
      ),
      body: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (_, snap) {
            if (snap.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${snap.data!.appName.validate()}', style: boldTextStyle(size: 20)),
                  2.height,
                  Container(height: 2, width: 110, color: primaryColor),
                  16.height,
                  Text('V ${snap.data!.version.validate()}', style: secondaryTextStyle()),
                  8.height,
                  Text(getStringAsync(ABOUT_US_PREF), style: secondaryTextStyle(), textAlign: TextAlign.start),
                ],
              ).paddingAll(16);
            }
            return SizedBox();
          }),
    );
  }
}
