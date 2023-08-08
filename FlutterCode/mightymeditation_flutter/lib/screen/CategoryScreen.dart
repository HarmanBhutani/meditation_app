import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:mighty_meditation/component/CategoryItemWidget.dart';
import 'package:mighty_meditation/network/RestApis.dart';
import 'package:mighty_meditation/screen/ViewAllScreen.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../utils/constant.dart';

class CategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';
  final bool isCategory;

  CategoryScreen({this.isCategory = false});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') loadInterstitialAds();
    }
  }

  @override
  void dispose() {
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') {
        if (mAdCategoryShowCount < int.parse(adsInterval)) {
          mAdCategoryShowCount++;
        } else {
          mAdCategoryShowCount = 0;
          showInterstitialAds();
        }
      }
    }
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(languages.lblCategory, showBack: widget.isCategory == true ? true : false),
      body: FutureBuilder<List<Category>>(
        future: getCategories(),
        builder: (_, snap) {
          if (snap.hasData) {
            return snap.data!.isNotEmpty
                ? SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        snap.data!.length,
                        (index) {
                          Category data = snap.data![index];
                          return AnimationConfiguration.staggeredGrid(
                            duration: Duration(milliseconds: 750),
                            columnCount: 1,
                            position: index,
                            child: CategoryItemWidget(data, onTap: () {
                              ViewAllScreen(title: data.name, categoryId: data.id.toInt(), isCategory: true).launch(context);
                            }),
                          );
                        },
                      ),
                    ).paddingOnly(bottom: appStore.playList.isNotEmpty ? 150 : 30, right: 16, left: 16, top: 16),
                  )
                : noDataWidget(context);
          }
          return snapWidgetHelper(snap, loadingWidget: mProgress());
        },
      ),
      bottomNavigationBar: widget.isCategory == true
          ? mCategoryViewAllBannerAds == '1'
              ? showBannerAds()
              : SizedBox()
          : SizedBox(),
    );
  }
}
