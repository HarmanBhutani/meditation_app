class DashboardResponse {
  Adsconfiguration? adsconfiguration;
  Appconfiguration? appconfiguration;
  OnesignalConfiguration? onesignalConfiguration;
  List<SliderResponse>? slider;
  List<Category>? popularAudio;
  List<Category>? latestAudio;
  List<Category>? category;

  DashboardResponse(
      {this.adsconfiguration, this.appconfiguration, this.onesignalConfiguration, this.slider, this.popularAudio, this.latestAudio, this.category});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    adsconfiguration = json['adsconfiguration'] != null ? new Adsconfiguration.fromJson(json['adsconfiguration']) : null;
    appconfiguration = json['appconfiguration'] != null ? new Appconfiguration.fromJson(json['appconfiguration']) : null;
    onesignalConfiguration = json['onesignal_configuration'] != null ? new OnesignalConfiguration.fromJson(json['onesignal_configuration']) : null;
    if (json['slider'] != null) {
      slider = <SliderResponse>[];
      json['slider'].forEach((v) {
        slider!.add(new SliderResponse.fromJson(v));
      });
    }
    if (json['popular_audio'] != null) {
      popularAudio = <Category>[];
      json['popular_audio'].forEach((v) {
        popularAudio!.add(new Category.fromJson(v));
      });
    }
    if (json['latest_audio'] != null) {
      latestAudio = <Category>[];
      json['latest_audio'].forEach((v) {
        latestAudio!.add(new Category.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.adsconfiguration != null) {
      data['adsconfiguration'] = this.adsconfiguration!.toJson();
    }
    if (this.appconfiguration != null) {
      data['appconfiguration'] = this.appconfiguration!.toJson();
    }
    if (this.onesignalConfiguration != null) {
      data['onesignal_configuration'] = this.onesignalConfiguration!.toJson();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.popularAudio != null) {
      data['popular_audio'] =
          this.popularAudio!.map((v) => v.toJson()).toList();
    }
    if (this.latestAudio != null) {
      data['latest_audio'] = this.latestAudio!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? categoryId;
  String? type;
  String? file;
  String? image;
  String? description;
  String? url;
  String? isPopular;
  String? createdAt;
  int? chapterCount;
  String? categoryName;
  List<Category>? audio;

  Category(
      {this.id,
        this.name,
        this.categoryId,
        this.type,
        this.file,
        this.image,
        this.description,
        this.url,
        this.isPopular,
        this.createdAt,
        this.chapterCount,
        this.categoryName,this.audio});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    type = json['type'];
    file = json['file'];
    image = json['image'];
    description = json['description'];
    url = json['url'];
    isPopular = json['is_popular'];
    createdAt = json['created_at'];
    chapterCount = json['chapter_count'];
    categoryName = json['category_name'];
    categoryName = json['category_name'];
    if (json['audio'] != null) {
      audio = <Category>[];
      json['audio'].forEach((v) {
        audio!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['type'] = this.type;
    data['file'] = this.file;
    data['image'] = this.image;
    data['description'] = this.description;
    data['url'] = this.url;
    data['is_popular'] = this.isPopular;
    data['created_at'] = this.createdAt;
    data['chapter_count'] = this.chapterCount;
    data['category_name'] = this.categoryName;
    if (this.audio != null) {
      data['audio'] = this.audio!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SliderResponse {
  String? id;
  String? title;
  String? url;
  String? image;
  String? status;
  String? imageUrl;

  SliderResponse({this.id, this.title, this.url, this.image, this.status, this.imageUrl});

  SliderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    image = json['image'];
    status = json['status'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['image'] = this.image;
    data['status'] = this.status;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Adsconfiguration {
  String? adsType;
  String? admobBannerId;
  String? admobInterstitialId;
  String? admobBannerIdIos;
  String? admobInterstitialIdIos;
  String? facebookBannerId;
  String? facebookInterstitialId;
  String? facebookBannerIdIos;
  String? facebookInterstitialIdIos;
  String? interstitialAdsInterval;
  String? bannerAdAudioList;
  String? bannerAdCategoryList;
  String? bannerAdAudioDetail;
  String? bannerAdAudioSearch;
  String? interstitialAdAudioList;
  String? interstitialAdCategoryList;
  String? interstitialAdAudioDetail;

  Adsconfiguration(
      {this.adsType,
        this.admobBannerId,
        this.admobInterstitialId,
        this.admobBannerIdIos,
        this.admobInterstitialIdIos,
        this.facebookBannerId,
        this.facebookInterstitialId,
        this.facebookBannerIdIos,
        this.facebookInterstitialIdIos,
        this.interstitialAdsInterval,
        this.bannerAdAudioList,
        this.bannerAdCategoryList,
        this.bannerAdAudioDetail,
        this.bannerAdAudioSearch,
        this.interstitialAdAudioList,
        this.interstitialAdCategoryList,
        this.interstitialAdAudioDetail});

  Adsconfiguration.fromJson(Map<String, dynamic> json) {
    adsType = json['ads_type'];
    admobBannerId = json['admob_banner_id'];
    admobInterstitialId = json['admob_interstitial_id'];
    admobBannerIdIos = json['admob_banner_id_ios'];
    admobInterstitialIdIos = json['admob_interstitial_id_ios'];
    facebookBannerId = json['facebook_banner_id'];
    facebookInterstitialId = json['facebook_interstitial_id'];
    facebookBannerIdIos = json['facebook_banner_id_ios'];
    facebookInterstitialIdIos = json['facebook_interstitial_id_ios'];
    interstitialAdsInterval = json['interstitial_ads_interval'];
    bannerAdAudioList = json['banner_ad_audio_list'];
    bannerAdCategoryList = json['banner_ad_category_list'];
    bannerAdAudioDetail = json['banner_ad_audio_detail'];
    bannerAdAudioSearch = json['banner_ad_audio_search'];
    interstitialAdAudioList = json['interstitial_ad_audio_list'];
    interstitialAdCategoryList = json['interstitial_ad_category_list'];
    interstitialAdAudioDetail = json['interstitial_ad_audio_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ads_type'] = this.adsType;
    data['admob_banner_id'] = this.admobBannerId;
    data['admob_interstitial_id'] = this.admobInterstitialId;
    data['admob_banner_id_ios'] = this.admobBannerIdIos;
    data['admob_interstitial_id_ios'] = this.admobInterstitialIdIos;
    data['facebook_banner_id'] = this.facebookBannerId;
    data['facebook_interstitial_id'] = this.facebookInterstitialId;
    data['facebook_banner_id_ios'] = this.facebookBannerIdIos;
    data['facebook_interstitial_id_ios'] = this.facebookInterstitialIdIos;
    data['interstitial_ads_interval'] = this.interstitialAdsInterval;
    data['banner_ad_audio_list'] = this.bannerAdAudioList;
    data['banner_ad_category_list'] = this.bannerAdCategoryList;
    data['banner_ad_audio_detail'] = this.bannerAdAudioDetail;
    data['banner_ad_audio_search'] = this.bannerAdAudioSearch;
    data['interstitial_ad_audio_list'] = this.interstitialAdAudioList;
    data['interstitial_ad_category_list'] = this.interstitialAdCategoryList;
    data['interstitial_ad_audio_detail'] = this.interstitialAdAudioDetail;
    return data;
  }
}
class Appconfiguration {
  String? facebook;
  String? instagram;
  String? twitter;
  String? whatsapp;
  String? privacyPolicy;
  String? termsCondition;
  String? contactUs;
  String? aboutUs;
  String? copyright;

  Appconfiguration({this.facebook, this.instagram, this.twitter, this.whatsapp, this.privacyPolicy, this.termsCondition, this.contactUs, this.aboutUs, this.copyright});

  Appconfiguration.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    whatsapp = json['whatsapp'];
    privacyPolicy = json['privacy_policy'];
    termsCondition = json['terms_condition'];
    contactUs = json['contact_us'];
    aboutUs = json['about_us'];
    copyright = json['copyright'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['whatsapp'] = this.whatsapp;
    data['privacy_policy'] = this.privacyPolicy;
    data['terms_condition'] = this.termsCondition;
    data['contact_us'] = this.contactUs;
    data['about_us'] = this.aboutUs;
    data['copyright'] = this.copyright;
    return data;
  }
}

class OnesignalConfiguration {
  String? appId;
  String? restApiKey;

  OnesignalConfiguration({this.appId, this.restApiKey});

  OnesignalConfiguration.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    restApiKey = json['rest_api_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['rest_api_key'] = this.restApiKey;
    return data;
  }
}
