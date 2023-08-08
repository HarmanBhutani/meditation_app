import 'package:mighty_meditation/utils/Extensions/shared_pref.dart';

const AppName = "Mighty Meditation";

/// Note: /api/ is required after your domain. Ex if your domain is www.abc.com then ${mBaseUrl} will be  https://www.abc.com/api/
const mBaseUrl = 'ADD YOUR BASE URL';

// Facebook
const FACEBOOK_KEY = 'ADD YOU FACEBOOK KEY';
const fbBannerId = "ADD YOUR BANNER ID ";
const fbBannerIdIos = "ADD YOUR BANNER IOS ID";
const fbInterstitialId = "ADD YOUR Interstitial ID ";
const fbInterstitialIdIos = "ADD YOUR IOS Interstitial ID";

//AdmobId
const adMobBannerId = "ADD YOUR ADMOB BANNER ID";
const adMobInterstitialId = "ADD YOUR IOS Interstitial ID";
const adMobBannerIdIos = "ADD YOUR IOS BANNER ID";
const adMobInterstitialIdIos = "ADD YOUR IOS Interstitial ID";

const mOneSignalID = 'ADD YOUR ONESIGNAL ID';

const ADD_TYPE = 'ads_type';
const NONE = 'none';
const FACEBOOK_BANNER_PLACEMENT_ID = 'facebook_banner_id';
const FACEBOOK_INTERSTITIAL_PLACEMENT_ID = 'facebook_interstitial_id';
const FACEBOOK_BANNER_PLACEMENT_ID_IOS = 'facebook_banner_id_ios';
const FACEBOOK_INTERSTITIAL_PLACEMENT_ID_IOS = 'facebook_interstitial_id_ios';

const ADMOB_BANNER_ID = 'admob_banner_id';
const ADMOB_INTERSTITIAL_ID = 'admob_interstitial_id';
const ADMOB_BANNER_ID_IOS = 'admob_banner_id_ios';
const ADMOB_INTERSTITIAL_ID_IOS = 'admob_interstitial_id_ios';

const INTERSTITIAL_ADS_INTERVAL = "interstitial_ads_interval";
const BANNER_AD_ITEM_LIST = "banner_ad_audio_list";
const BANNER_AD_CATEGORY_LIST = "banner_ad_category_list";
const BANNER_AD_DETAIL = "banner_ad_audio_detail";
const BANNER_AD_AUDIO_SEARCH = "banner_ad_audio_search";
const INTERSTITIAL_AD_AUDIO_LIST = "interstitial_ad_audio_list";
const INTERSTITIAL_AD_CATEGORY_LIST = "interstitial_ad_category_list";
const INTERSTITIAL_AD_AUDIO_DETAIL = "interstitial_ad_audio_detail";

const TERMS_AND_CONDITION_PREF = 'TermsAndConditionPref';
const PRIVACY_POLICY_PREF = 'PrivacyPolicyPref';
const CONTACT_PREF = 'ContactPref';
const ABOUT_US_PREF = 'AboutUsPref';
const FACEBOOK = 'facebook';
const WHATSAPP = 'whatsapp';
const TWITTER = 'twitter';
const INSTAGRAM = 'instagram';
const COPYRIGHT = 'copyright';
const WISHLIST_ITEM_LIST = 'WISHLIST_ITEM_LIST';
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const TEST = 'TEST';
const IS_FIRST_TIME = 'IS_FIRST_TIME';
final String chooseTopicList = 'chooseTopicList';

const CROSS_AXIS_COUNT = 'CROSS_AXIS_COUNT';

const msg = 'message';

const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

class DefaultValues {
  final String defaultLanguage = "en";
}

DefaultValues defaultValues = DefaultValues();

String isGoogleAds = "admob";
String isFacebookAds = "facebook";

String adsInterval = getStringAsync(INTERSTITIAL_ADS_INTERVAL);

String mSearchBannerAds = getStringAsync(BANNER_AD_AUDIO_SEARCH);
String mDetailBannerAds = getStringAsync(BANNER_AD_DETAIL);
String mViewAllBannerAds = getStringAsync(BANNER_AD_ITEM_LIST);
String mCategoryViewAllBannerAds = getStringAsync(BANNER_AD_CATEGORY_LIST);

String mCategoryViewAllInterstitialAds = getStringAsync(INTERSTITIAL_AD_CATEGORY_LIST);
String mDetailInterstitialAds = getStringAsync(INTERSTITIAL_AD_AUDIO_DETAIL);
String mViewAllInterstitialAds = getStringAsync(INTERSTITIAL_AD_AUDIO_LIST);
