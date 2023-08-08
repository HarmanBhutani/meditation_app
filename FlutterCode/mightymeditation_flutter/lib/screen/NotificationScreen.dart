import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/model/DashboardResponse.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/string_extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart';
import '../component/AudioComponent.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/PositionSeekWidget.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/readmore.dart';

class NotificationScreen extends StatefulWidget {
  final OSNotification? data;

  NotificationScreen({this.data});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();
  String? name;
  String? img;
  String? type;
  String? url;
  String? dec;
  bool isPlayingSeries = false;
  bool isPlaing=true;

  @override
  void initState() {
    super.initState();
    init();

    FacebookAudienceNetwork.init(testingId: FACEBOOK_KEY, iOSAdvertiserTrackingEnabled: true);
    if (mDetailInterstitialAds == '1') loadInterstitialAds();
  }

  Future<void> init() async {
    print("================> title ---------------- ${widget.data!.title}");
    print("================> body ----------------- ${widget.data!.body}");
    name = widget.data!.title;
    img = widget.data!.bigPicture;
    dec = widget.data!.body!;
    getAudio();
  }

  getAudio() async {
    if (assetsAudioPlayer.isPlaying.value == true) {
      audios.clear();
      await nMusic(ind: index, start: true, context: context, choiceIndex: 1, url: widget.data!.launchUrl);
    } else {
      await nMusic(ind: index, start: true, context: context, choiceIndex: 1, url: widget.data!.launchUrl);
    }
    appStore.setPlay(assetsAudioPlayer.isPlaying.value);
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
                Share.share('${languages.lblShare}\n${widget.data!.launchUrl!}');
              });
            },
            icon: Icon(Ionicons.share_social),
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
                assetsAudioPlayer.builderRealtimePlayingInfos(builder: (context, RealtimePlayingInfos? infos) {
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
                }).paddingBottom(16),
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
                    PlayerBuilder.isPlaying(
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
                                            isPlaing=!isPlaing;
                                            setState(() {});
                                          },
                                          iconSize: 35,
                                          icon: Icon(
                                            isPlaing==true?Icons.pause:Icons.play_arrow ,
                                            color: Colors.white,
                                          ),
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
          ],
        ),
        bottomNavigationBar: mDetailBannerAds == '1' ? showBannerAds() : SizedBox());
  }
}

nMusic({int? ind, String? url, int? choiceIndex, bool? start, BuildContext? context}) async {
  i = ind!;
  print("===========================================?  $url");
  audios.add(
    Audio.network(
      url!,
      metas: Metas(
        id: "",
        title: "",
        artist: "",
        album: '',
      ),
    ),
  );
  try {
    assetsAudioPlayer.onErrorDo = (error) {
      error.player.stop();
    };
    assetsAudioPlayer.playlistAudioFinished.listen((finished) {
      appStore.clearPlayList();
    });
    await assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: choiceIndex == 0 ? 0 : ind),
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      notificationSettings: NotificationSettings(seekBarEnabled: true, prevEnabled: false, nextEnabled: false, playPauseEnabled: true),
      autoStart: start!,
    );
  } catch (t) {
    error = t.toString();
    appStore.clearPlayList();
    print("error is .................>>>$error");
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(languages.lblAudioNotAvailable, textAlign: TextAlign.center, style: primaryTextStyle(color: Colors.white)),
      backgroundColor: primaryColor,
      behavior: SnackBarBehavior.floating,
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: radius()),
    ));
    await assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      showNotification: true,
      notificationSettings: NotificationSettings(seekBarEnabled: false),
      autoStart: false,
    );
  }
}
