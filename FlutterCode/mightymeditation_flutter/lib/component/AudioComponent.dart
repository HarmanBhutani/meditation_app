import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mighty_meditation/utils/Extensions/text_styles.dart';
import 'package:mighty_meditation/utils/colors.dart';
import '../main.dart';
import '../utils/Extensions/decorations.dart';

String error = "";
int index = 0;
int i = 0;

AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('music');

final audios = <Audio>[];

mMusic({int? ind, int? choiceIndex, bool? start, BuildContext? context}) async {
  i = ind!;

  if (appStore.playList[ind].type=='url') {
    print(appStore.playList[ind].url);
  }else{
    print(appStore.playList[ind].file);
  }

  for (int i = 0; i < appStore.playList.length; i++) {
    index = i;
    audios.add(
      Audio.network(
        appStore.playList[index].type=='url'?appStore.playList[index].url!:appStore.playList[index].file!,
        metas: Metas(
          id: appStore.playList[index].id!,
          title: appStore.playList[index].name!,
          artist: appStore.playList[index].categoryName,
          album: '',
          image: MetasImage.network(appStore.playList[index].image!),
        ),
      ),
    );
  }
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
