import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/model/DashboardResponse.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/shared_pref.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart';
import '../component/AudioComponent.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/PositionSeekWidget.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/readmore.dart';

class AudioDetailScreen extends StatefulWidget {
  final Category? data;

  AudioDetailScreen({this.data});

  @override
  _AudioDetailScreenState createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends State<AudioDetailScreen> with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool isLastPage = false;
  List<Category> seriesDataList = [];
  String? name;
  String? img;
  String? type;
  String? url;
  String? dec;

  Category? mMata;
  bool isPlayingSeries = false;

  @override
  void initState() {
    super.initState();
    init();

    FacebookAudienceNetwork.init(testingId: FACEBOOK_KEY, iOSAdvertiserTrackingEnabled: true);
    if (mDetailInterstitialAds == '1') loadInterstitialAds();
  }

  Future<void> init() async {
    name = widget.data!.name;
    img = widget.data!.image;
    type = widget.data!.type;
    mMata = widget.data!;
    dec = widget.data!.description!;
    if (type != SOURCE_TYPE_SERIES) getAudio();

    if (type == SOURCE_TYPE_SERIES) getSeriesData();
  }

  Future<void> getSeriesData() async {
    appStore.setLoading(true);
    await getChapter(id: widget.data!.id.toInt(), page: currentPage).then((res) async {
      if (!mounted) return;
      appStore.setLoading(false);
      isLastPage = false;
      if (currentPage == 1) {
        seriesDataList.clear();
      }
      seriesDataList.addAll(res);
      assetsAudioPlayer.pause();
      removeKey(TEST);
      setState(() {});
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      toast(e.toString());
      appStore.setLoading(false);
    });
    setState(() {});
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      init();
    }
  }

  getAudio() async {
    if (assetsAudioPlayer.isPlaying.value == true) {
      if (getStringAsync(TEST) == widget.data!.id) {
        setState(() {});
      } else {
        appStore.clearPlayList();
        appStore.addPlayListItem(widget.data!);
        audios.clear();
        await mMusic(ind: index, start: true, context: context, choiceIndex: 1);
      }
    } else {
      appStore.clearPlayList();
      appStore.addPlayListItem(widget.data!);
      audios.clear();
      await mMusic(ind: index, start: true, context: context, choiceIndex: 1);
    }
    appStore.setPlay(assetsAudioPlayer.isPlaying.value);
    setValue(TEST, widget.data!.id);
    setState(() {});
  }

  @override
  void dispose() {
    if (mDetailInterstitialAds == '1') {
      if (mAdDetailShowCount < int.parse(adsInterval)) {
        mAdDetailShowCount++;
      } else {
        mAdDetailShowCount = 0;
        showInterstitialAds();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget("", color: primaryColor, showBack: true, textColor: Colors.white, actions: [
          IconButton(
            onPressed: () {
              PackageInfo.fromPlatform().then((value) {
                Share.share('${languages.lblShare}\n${widget.data!.url}');
              });
            },
            icon: Icon(Ionicons.share_social),
          ),
          IconButton(
            onPressed: () {
              Category mWishListModel = Category();
              mWishListModel = widget.data!;
              wishListStore.addToWishList(mWishListModel);
              setState(() {});
            },
            icon: Icon(wishListStore.isItemInWishlist(widget.data!.id.toInt()) == false ? MaterialIcons.favorite_border : MaterialIcons.favorite),
          ),
        ]),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cachedImage(img.toString(), fit: BoxFit.fill, width: context.width(), height: context.height() * 0.38)
                    .cornerRadiusWithClipRRect(defaultRadius)
                    .paddingOnly(left: 20, right: 20, top: 20, bottom: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data!.categoryName.validate(), style: secondaryTextStyle()),
                    2.height,
                    Text(parseHtmlStringWidget(name.validate()), textAlign: TextAlign.start, style: boldTextStyle(size: 22)),
                    4.height,
                    ReadMoreText(
                      dec.toString(),
                      trimLines: 3,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: secondaryTextStyle(),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
                10.height,
                assetsAudioPlayer
                    .builderRealtimePlayingInfos(builder: (context, RealtimePlayingInfos? infos) {
                      if (infos == null) {
                        return SizedBox();
                      } else {
                        if (infos.isPlaying) {
                          return PositionSeekWidget(
                              currentPosition: infos.currentPosition,
                              duration: infos.duration,
                              seekTo: (to) {
                                assetsAudioPlayer.seek(to);
                              });
                        } else {
                          return PositionSeekWidget(currentPosition: infos.currentPosition, duration: infos.duration, seekTo: (to) {});
                        }
                      }
                    })
                    .paddingBottom(16)
                    .visible(type != SOURCE_TYPE_SERIES),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: -10));
                      },
                      icon: Icon(MaterialCommunityIcons.rewind_10),
                    ),
                    30.width,
                    widget.data!.type == SOURCE_TYPE_SERIES && seriesDataList.length > 0
                        ? Observer(builder: (context) {
                            return Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                              child: IconButton(
                                  onPressed: () {
                                    assetsAudioPlayer.playOrPause();
                                    if (assetsAudioPlayer.isPlaying.value == true) {
                                      isPlayingSeries = false;
                                    } else {
                                      isPlayingSeries = true;
                                    }
                                    setState(() {});
                                  },
                                  iconSize: 35,
                                  icon: Icon(isPlayingSeries == true ? Icons.pause : Icons.play_arrow, color: Colors.white)),
                            );
                          })
                        : PlayerBuilder.isPlaying(
                            player: assetsAudioPlayer,
                            builder: (context, isPlaying) {
                              isPlayingSeries = isPlaying;
                              return PlayerBuilder.isBuffering(
                                  player: assetsAudioPlayer,
                                  builder: (context, isBuffering) {
                                    return isBuffering
                                        ? Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2).paddingAll(6))
                                        : Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                                            child: IconButton(
                                              onPressed: () async {
                                                assetsAudioPlayer.playOrPause();
                                                setState(() {});
                                              },
                                              iconSize: 35,
                                              icon: Icon(
                                                  isPlayingSeries == true
                                                      ? getStringAsync(TEST) != widget.data!.id
                                                          ? Icons.play_arrow
                                                          : Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white),
                                            ),
                                          );
                                  });
                            }),
                    30.width,
                    IconButton(
                        onPressed: () {
                          assetsAudioPlayer.seekBy(Duration(seconds: 10));
                        },
                        icon: Icon(MaterialCommunityIcons.fast_forward_10)),
                  ],
                ).visible(type != SOURCE_TYPE_SERIES || isPlayingSeries == true),
              ],
            ),
            widget.data!.type == SOURCE_TYPE_SERIES && seriesDataList.length > 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.data!.type == SOURCE_TYPE_SERIES && seriesDataList.length > 0) Text('Sessions', style: boldTextStyle()).paddingSymmetric(vertical: 8),
                      if (widget.data!.type == SOURCE_TYPE_SERIES)
                        Container(
                          width: context.width(),
                          child: Column(
                            children: List.generate(seriesDataList.length, (index) {
                              return GestureDetector(
                                onTap: () async {
                                  await handleOnTap(seriesDataList[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: boxDecorationRoundedWithShadowWidget(defaultRadius.toInt(), backgroundColor: context.cardColor, spreadRadius: 0.5, blurRadius: 1),
                                  child: Row(
                                    children: [
                                      Text('${index + 1}'.toString(), style: secondaryTextStyle()),
                                      8.width,
                                      Text(parseHtmlStringWidget(seriesDataList[index].name!), textAlign: TextAlign.start, style: boldTextStyle()).expand(),
                                      Observer(builder: (context) {
                                        return GestureDetector(
                                          onTap: () async {
                                            await handleOnTap(seriesDataList[index]);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: boxDecorationRoundedWithShadowWidget(21,
                                                backgroundColor: primaryColor,
                                                spreadRadius: 1,
                                                blurRadius: 0.5,
                                                shadowColor: appStore.isDarkModeOn ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.2)),
                                            child: Icon(
                                              isPlayingSeries == true
                                                  ? getStringAsync(TEST) != seriesDataList[index].id
                                                      ? Icons.play_arrow
                                                      : Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      16.height,
                    ],
                  ).paddingSymmetric(horizontal: 16)
                : SizedBox(),
          ],
        ),
        bottomNavigationBar: mDetailBannerAds == '1' ? showBannerAds() : SizedBox());
  }

  handleOnTap(Category data) async {
    if (data.url != null && data.url!.isNotEmpty) {
      name = data.name;
      img = data.image;
      type = data.type;
      url = data.url;
      dec = data.description;

      if (assetsAudioPlayer.isPlaying.value == true) {
        if (getStringAsync(TEST) == data.id) {
          assetsAudioPlayer.playOrPause();
          if (assetsAudioPlayer.isPlaying.value == true) {
            isPlayingSeries = false;
          } else {
            isPlayingSeries = true;
          }
        } else {
          isPlayingSeries = true;
          appStore.clearPlayList();
          appStore.addPlayListItem(data);
          audios.clear();
          await mMusic(ind: index, start: true, context: context, choiceIndex: 1);
        }
      } else {
        isPlayingSeries = true;
        appStore.clearPlayList();
        appStore.addPlayListItem(data);
        audios.clear();
        await mMusic(ind: index, start: true, context: context, choiceIndex: 1);
      }
      appStore.setPlay(assetsAudioPlayer.isPlaying.value);
      setValue(TEST, data.id);
      setState(() {});
    }
  }
}
