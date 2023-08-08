import 'dart:convert';

import 'package:http/http.dart';
import 'package:mighty_meditation/model/DashboardResponse.dart';
import 'package:mighty_meditation/network/NetworkUtils.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';

import '../utils/Extensions/shared_pref.dart';

Future<List<Category>> getCategories() async {
  Iterable it = await (handleResponse(await buildHttpResponse('category.php')));
  return it.map((e) => Category.fromJson(e)).toList();
}

//
Future<DashboardResponse> getDashboard() async {
  return await handleResponse(await buildHttpResponse('dashboard.php')).then((value) async {
    var res = DashboardResponse.fromJson(value);

    if (res.appconfiguration != null) {
      await setValue(TERMS_AND_CONDITION_PREF, res.appconfiguration!.termsCondition.validate());
      await setValue(PRIVACY_POLICY_PREF, res.appconfiguration!.privacyPolicy.validate());
      await setValue(CONTACT_PREF, res.appconfiguration!.contactUs.validate());
      await setValue(ABOUT_US_PREF, res.appconfiguration!.aboutUs.validate());
      await setValue(FACEBOOK, res.appconfiguration!.facebook.validate());
      await setValue(WHATSAPP, res.appconfiguration!.whatsapp.validate());
      await setValue(TWITTER, res.appconfiguration!.twitter.validate());
      await setValue(INSTAGRAM, res.appconfiguration!.instagram.validate());
      await setValue(COPYRIGHT, res.appconfiguration!.copyright.validate());
    }
    if (res.adsconfiguration != null) {
      //ad
      await setValue(ADD_TYPE, res.adsconfiguration!.adsType);
      await setValue(FACEBOOK_BANNER_PLACEMENT_ID, res.adsconfiguration!.facebookBannerId.validate());
      await setValue(FACEBOOK_INTERSTITIAL_PLACEMENT_ID, res.adsconfiguration!.facebookInterstitialId.validate());
      await setValue(FACEBOOK_BANNER_PLACEMENT_ID_IOS, res.adsconfiguration!.facebookBannerIdIos.validate());
      await setValue(FACEBOOK_INTERSTITIAL_PLACEMENT_ID_IOS, res.adsconfiguration!.facebookInterstitialIdIos.validate());

      await setValue(ADMOB_BANNER_ID, res.adsconfiguration!.admobBannerId.validate());
      await setValue(ADMOB_INTERSTITIAL_ID, res.adsconfiguration!.admobInterstitialId.validate());
      await setValue(ADMOB_BANNER_ID_IOS, res.adsconfiguration!.admobBannerIdIos.validate());
      await setValue(ADMOB_INTERSTITIAL_ID_IOS, res.adsconfiguration!.facebookInterstitialIdIos.validate());

      await setValue(INTERSTITIAL_ADS_INTERVAL, res.adsconfiguration!.interstitialAdsInterval.validate());
      await setValue(BANNER_AD_ITEM_LIST, res.adsconfiguration!.bannerAdAudioList.validate());
      await setValue(BANNER_AD_CATEGORY_LIST, res.adsconfiguration!.bannerAdCategoryList.validate());
      await setValue(BANNER_AD_DETAIL, res.adsconfiguration!.bannerAdAudioDetail.validate());
      await setValue(BANNER_AD_AUDIO_SEARCH, res.adsconfiguration!.bannerAdAudioSearch.validate());
      await setValue(INTERSTITIAL_AD_AUDIO_LIST, res.adsconfiguration!.interstitialAdAudioList.validate());
      await setValue(INTERSTITIAL_AD_CATEGORY_LIST, res.adsconfiguration!.interstitialAdCategoryList.validate());
      await setValue(INTERSTITIAL_AD_AUDIO_DETAIL, res.adsconfiguration!.interstitialAdAudioDetail.validate());
    }
    return res;
  });
}

Future<List<Category>> getMeditationData({List<String>? list, bool? isPopular = false, bool? isFeature = false, int? categoryId, bool? isCategory = false, bool? isLatest = false, int? page}) async {
  var multiPartRequest = MultipartRequest('POST', Uri.parse('$mBaseUrl${'audio.php'}'));
  if (isPopular == true) {
    multiPartRequest.fields['is_popular'] = "true";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isFeature == true) {
    multiPartRequest.fields['is_featured'] = "true";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isCategory == true) {
    multiPartRequest.fields['category_id'] = "$categoryId";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isLatest == true) {
    multiPartRequest.fields['order'] = "desc";
    multiPartRequest.fields['order_by'] = "id";
    multiPartRequest.fields['page'] = page.toString();
  } else {
    multiPartRequest.fields['category_ids'] = "$list";
  }
  multiPartRequest.headers.addAll(buildHeaderTokens());
  Response response = await Response.fromStream(await multiPartRequest.send());
  var responseJson = json.decode(response.body);
  Iterable? mCategory = responseJson;
  return mCategory!.map((e) => Category.fromJson(e)).toList();
}

Future<List<Category>> getChapter({int? id, int? page}) async {
  Iterable it = await (handleResponse(await buildHttpResponse('chapter.php?audio_id=$id&page=$page')));
  return it.map((e) => Category.fromJson(e)).toList();
}
