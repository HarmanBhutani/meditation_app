import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mighty_meditation/component/SliderWidget.dart';
import 'package:mighty_meditation/screen/AudioDetailScreen.dart';
import 'package:mighty_meditation/screen/ViewAllScreen.dart';
import 'package:mighty_meditation/screen/WebViewScreen.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import '../component/CategoryItemWidget.dart';
import '../component/ItemWidget.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/HorizontalList.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';
import 'CategoryScreen.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Category> mCategoryList = [];
  List<Category> mPopularList = [];
  List<Category> mLatestList = [];
  List<Category> mSuggestedList = [];
  List<String> mCategoryId = [];
  List<SliderResponse> mSliderList = [];

  int? currentIndex = 0;
  String? mErrorMsg = "";

  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<String>? mIdList = getStringListAsync(chooseTopicList);

    appStore.setLoading(true);
    mIdList!.forEach((element) {
      mCategoryId.add(element);
    });

    getMeditationData(list: mCategoryId).then((res) {
      mSuggestedList = res;
      setState(() {});
    });

    getDashboard().then((res) {
      mSliderList = res.slider!;
      mPopularList = res.popularAudio!;
      mLatestList = res.latestAudio!;
      mCategoryList = res.category!;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      mErrorMsg = e.toString();
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeading(String title, {int? id, bool? isLatest = false, bool? isPopular = false, bool? isSuggested = false, bool? isCategory = false, bool? isCategoryViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: boldTextStyle(size: 20, fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily)),
        IconButton(
          onPressed: () {
            if (isCategoryViewAll == true) {
              CategoryScreen(isCategory: true).launch(context);
            } else {
              ViewAllScreen(categoryId: id, title: title, isLatest: isLatest, isCategory: isCategory, isSuggested: isSuggested, isPopular: isPopular).launch(context);
            }
          },
          icon: Icon(Icons.keyboard_arrow_right, color: textSecondaryColor),
        ),
      ],
    ).paddingOnly(left: 16, right: appStore.selectedLanguageCode == "ar" ? 16 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(AppName, showBack: false),
      body: RefreshIndicator(
        onRefresh: () async {
          await 2.seconds.delay;
          setState(() {});
        },
        child: Stack(
          children: [
            ListView(
              children: [
                if (mSliderList.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: context.width(),
                        child: PageView.builder(
                          itemCount: mSliderList.length,
                          controller: pageController,
                          itemBuilder: (context, i) {
                            return SliderWidget(
                              data: mSliderList[i],
                              onTap: () {
                                WebViewScreen(mInitialUrl: mSliderList[i].url).launch(context);
                              },
                            );
                          },
                          onPageChanged: (int i) {
                            currentIndex = i;
                            setState(() {});
                          },
                        ),
                      ),
                      dotIndicator(mSliderList, currentIndex).paddingTop(8),
                    ],
                  ).paddingTop(16),
                if (mLatestList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mHeading(languages.lblLatest, isLatest: true),
                      HorizontalList(
                          itemCount: mLatestList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          itemBuilder: (BuildContext context1, int index) {
                            return ItemWidget(mLatestList[index], isGrid: false, onTap: () async {
                              AudioDetailScreen(data: mLatestList[index]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            });
                          }),
                      16.height,
                    ],
                  ),
                if (mCategoryList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mHeading(languages.lblCategory, isCategory: true, isCategoryViewAll: true),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 8,
                        spacing: 8,
                        children: List.generate(
                          mCategoryList.length,
                          (index) {
                            return AnimationConfiguration.staggeredGrid(
                              duration: Duration(milliseconds: 750),
                              columnCount: 1,
                              position: index,
                              child: CategoryItemWidget(mCategoryList[index], isDashboard: true, onTap: () {
                                ViewAllScreen(title: mCategoryList[index].name, categoryId: mCategoryList[index].id!.toInt(), isCategory: true).launch(context);
                              }),
                            );
                          },
                        ),
                      ).paddingOnly(left: 16, right: 16)
                    ],
                  ),
                8.height,
                if (mSuggestedList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mHeading(languages.lblSuggested, isSuggested: true),
                      HorizontalList(
                          itemCount: mSuggestedList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          itemBuilder: (BuildContext context1, int index) {
                            return ItemWidget(mSuggestedList[index], isPopular: true, onTap: () async {
                              AudioDetailScreen(data: mSuggestedList[index]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            });
                          }),
                      16.height,
                    ],
                  ),
                if (mPopularList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mHeading(languages.lblPopularStation, isPopular: true),
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 12,
                        spacing: 12,
                        children: List.generate(
                          mPopularList.length,
                          (index) {
                            return AnimationConfiguration.staggeredGrid(
                              duration: Duration(milliseconds: 750),
                              columnCount: 1,
                              position: index,
                              child: ItemWidget(mPopularList[index], isGrid: true, onTap: () {
                                AudioDetailScreen(data: mPopularList[index]).launch(context);
                              }),
                            );
                          },
                        ),
                      ).paddingOnly(left: 16, right: 16),
                      16.height
                    ],
                  ),
              ],
            ),
            mProgress().center().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
