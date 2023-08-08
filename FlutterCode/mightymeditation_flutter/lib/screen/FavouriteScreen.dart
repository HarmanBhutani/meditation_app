import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mighty_meditation/component/ItemWidget.dart';
import 'package:mighty_meditation/main.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../component/DialogComponent.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import 'AudioDetailScreen.dart';

class FavouriteScreen extends StatefulWidget {
  static String tag = '/FavouriteScreen';

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: accentColor, borderRadius: BorderRadius.only(topLeft: radiusCircular(), bottomLeft: radiusCircular())),
      margin: EdgeInsets.only(bottom: 16),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            20.width,
            Icon(Icons.delete, color: Colors.white),
            Text(" " + languages.lblRemove, style: primaryTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.right),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(languages.lblFavourite),
      body: Observer(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 8, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wishListStore.wishList.isNotEmpty
                  ? Column(
                      children: List.generate(wishListStore.wishList.length, (index) {
                        return Dismissible(
                          key: Key(wishListStore.wishList[index].id.toString()),
                          secondaryBackground: SizedBox(),
                          background: slideLeftBackground(),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              return showDialogBox(context, languages.lblRemoveFavourite, onCancelCall: () {
                                finish(context);
                              }, onCall: () {
                                wishListStore.addToWishList(wishListStore.wishList[index]);
                                finish(context);
                              });
                            } else {
                              return null;
                            }
                          },
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            delay: 200.milliseconds,
                            duration: Duration(milliseconds: 800),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ItemWidget(wishListStore.wishList[index], isFavourite: true, onTap: () async {
                                  AudioDetailScreen(data: wishListStore.wishList[index]).launch(context);
                                }),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : noDataWidget(context).expand(),
            ],
          ),
        );
      }),
    );
  }
}
