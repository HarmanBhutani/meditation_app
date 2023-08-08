import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import '../component/AdMobComponent.dart';
import '../component/FacebookdComponent.dart';
import '../main.dart';
import 'Extensions/Commons.dart';
import 'Extensions/Constants.dart';
import 'Extensions/shared_pref.dart';
import 'Extensions/string_extensions.dart';
import 'Extensions/text_styles.dart';
import 'colors.dart';
import 'constant.dart';
import 'images.dart';

Widget cachedImage(String? url, {double? height, Color? color, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(ic_placeholder, height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget setImage(String value) {
  return Image.asset(value, height: 18, width: 18, color: Colors.white).paddingAll(16);
}

Widget mProgress() {
  return CircularProgressIndicator(color: primaryColor).center();
}

Widget noDataWidget(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(ic_noData, fit: BoxFit.cover, height: 100, width: 100),
      8.height,
      Text(languages.lblNoDataFound, style: boldTextStyle()),
    ],
  ).center();
}

appBar(String? title, {bool? showBack = false, List<Widget>? action}) {
  return appBarWidget(title.validate(),
      color: primaryColor, elevation: 0, titleTextStyle: primaryTextStyle(size: 22, color: Colors.white), textColor: Colors.white, showBack: showBack == true ? true : false, actions: action);
}

InputDecoration inputDecoration(BuildContext context, {String? label, Widget? prefixIcon}) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.theme.colorScheme.error)),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.transparent)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: context.theme.colorScheme.error)),
    alignLabelWithHint: true,
    filled: true,
    isDense: true,
    labelText: label ?? "Sample Text",
    labelStyle: secondaryTextStyle(),
  );
}

void loadInterstitialAds() {
  getStringAsync(ADD_TYPE) != NONE
      ? getStringAsync(ADD_TYPE) == isGoogleAds
          ? createInterstitialAd()
          : loadFacebookInterstitialAd()
      : SizedBox();
}

void showInterstitialAds() {
  getStringAsync(ADD_TYPE) != NONE
      ? getStringAsync(ADD_TYPE) == isGoogleAds
          ? adShow()
          : showFacebookInterstitialAd()
      : SizedBox();
}

Widget showBannerAds() {
  return getStringAsync(ADD_TYPE) != NONE
      ? getStringAsync(ADD_TYPE) == isGoogleAds
          ? Container(
              height: 60,
              child: AdWidget(
                ad: BannerAd(
                  adUnitId: kReleaseMode
                      ? getBannerAdUnitId()!
                      : Platform.isIOS
                          ? adMobBannerIdIos
                          : adMobBannerId,
                  size: AdSize.banner,
                  request: AdRequest(),
                  listener: BannerAdListener(),
                )..load(),
              ),
            )
          : loadFacebookBannerId()
      : SizedBox();
}
