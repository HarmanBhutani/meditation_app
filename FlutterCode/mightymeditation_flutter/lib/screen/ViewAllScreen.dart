import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/component/ItemWidget.dart';
import 'package:mighty_meditation/network/RestApis.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../model/LayoutTypesSelection.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/shared_pref.dart';
import 'AudioDetailScreen.dart';

class ViewAllScreen extends StatefulWidget {
  static String tag = '/ViewAllScreen';
  final int? categoryId;
  final bool? isFeatured;
  final bool? isPopular;
  final bool? isSuggested;
  final bool? isLatest;
  final String? title;
  final bool? isCategory;

  ViewAllScreen({this.categoryId, this.title, this.isFeatured = false, this.isLatest = false, this.isCategory = false, this.isPopular = false, this.isSuggested = false});

  @override
  ViewAllScreenState createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
  ScrollController scrollController = ScrollController();

  List<Category> mMeditationList = [];
  List<String> mCategoryId = [];
  List<LayoutTypesSelection> select = [];

  int crossAxisCount = 2;
  int? crossValue = 1;
  int currentPage = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    crossValue = crossAxisCount;
  }

  init() async {
    log(getIntAsync(CROSS_AXIS_COUNT));
    var crossAxisCount1 = getIntAsync(CROSS_AXIS_COUNT, defaultValue: 0);
    setState(() {
      crossAxisCount = crossAxisCount1;
    });
    select.clear();

    select.add(LayoutTypesSelection(image: Icon(Icons.list_rounded), isSelected: false));
    select.add(LayoutTypesSelection(image: Icon(Ionicons.ios_grid_outline), isSelected: false));
    setState(() {});

    getAPI();
    scrollController.addListener(() {
      scrollHandler();
    });

    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') loadInterstitialAds();
    } else {
      if (mViewAllInterstitialAds == '1') loadInterstitialAds();
    }
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      init();
    }
  }

  loadData(List<Category> value) {
    if (!mounted) return;
    setState(() {
      appStore.setLoading(false);
      isLastPage = false;
      if (currentPage == 1) {
        mMeditationList.clear();
      }
      mMeditationList.addAll(value);
    });
  }

  catchData() {
    if (!mounted) return;
    isLastPage = true;
    appStore.setLoading(false);
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
    } else {
      if (mViewAllInterstitialAds == '1') {
        if (mAdShowCount < int.parse(adsInterval)) {
          mAdShowCount++;
        } else {
          mAdShowCount = 0;
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

  getAPI() {
    appStore.setLoading(true);
    if (widget.isFeatured == true) {
      return getMeditationData(isFeature: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isPopular == true) {
      return getMeditationData(isPopular: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isSuggested == true) {
      List<String>? mIdList = getStringListAsync(chooseTopicList);
      mIdList!.forEach((element) {
        mCategoryId.add(element);
      });
      return getMeditationData(list: mCategoryId, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isCategory == true) {
      return getMeditationData(isCategory: true, categoryId: widget.categoryId, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    }
    if (widget.isLatest == true) {
      return getMeditationData(isLatest: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else {
      return getMeditationData(isFeature: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    }
  }

  Widget mGridBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(
              mMeditationList.length,
              (index) {
                Category data = mMeditationList[index];
                return AnimationConfiguration.staggeredGrid(
                  duration: Duration(milliseconds: 750),
                  columnCount: 1,
                  position: index,
                  child: ItemWidget(data, isGrid: true, onTap: () async {
                    AudioDetailScreen(data: data).launch(context);
                  }).paddingOnly(top: 16, left: 16),
                );
              },
            ),
          ),
        ),
        if (!appStore.isLoading && mMeditationList.isEmpty) noDataWidget(context).center(),
        mProgress().center().visible(appStore.isLoading),
      ],
    );
  }

  Widget mListBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(
              mMeditationList.length,
              (index) {
                Category data = mMeditationList[index];
                return AnimationConfiguration.staggeredGrid(
                  duration: Duration(milliseconds: 750),
                  columnCount: 1,
                  position: index,
                  child: ItemWidget(data, isFavourite: true, onTap: () {
                    AudioDetailScreen(data: data).launch(context);
                  }),
                );
              },
            ),
          ),
        ),
        if (!appStore.isLoading && mMeditationList.isEmpty) noDataWidget(context).center(),
        mProgress().center().visible(appStore.isLoading),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBar(
          widget.title!,
          showBack: true,
          action: [
            Container(
              child: ListView.builder(
                itemCount: select.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: IconButton(
                      icon: select[index].image!,
                      iconSize: 24,
                      color: select[index].isSelected! ? Colors.white : Colors.white70,
                      onPressed: () async {
                        init();
                        select[index].isSelected = !select[index].isSelected!;
                        setState(() {});
                        if (index == 0)
                          crossValue = 1;
                        else
                          crossValue = 2;
                        setValue(CROSS_AXIS_COUNT, crossValue);
                        crossAxisCount = crossValue!;
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: widget.isCategory == true
            ? mCategoryViewAllBannerAds == '1'
                ? showBannerAds()
                : SizedBox()
            : mViewAllBannerAds == '1'
                ? showBannerAds()
                : SizedBox(),
        body: crossAxisCount == 1 ? mListBody() : mGridBody(),
      );
    });
  }
}
