import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mighty_meditation/utils/Extensions/Constants.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/shared_pref.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import 'DashboardScreen.dart';

class ChooseInterest extends StatefulWidget {
  final bool? isSetting;

  const ChooseInterest({this.isSetting = false}) : super();

  @override
  _ChooseInterestState createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {
  List<Category>? catResponse = [];
  List<String> selectedId = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getCategoryList();
  }

  getCategoryList() async {
    appStore.setLoading(true);
    await getCategories().then((value) {
      catResponse = value;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isSetting == true ? appBar("", showBack: true) : PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(0.0)),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Visibility(
            visible: catResponse != null && catResponse!.isNotEmpty,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: catResponse != null && catResponse!.isNotEmpty ? 16 : context.statusBarHeight + 50, bottom: 132, right: 16, left: 16),
                  child: Column(
                    children: [
                      Text(languages.chooseInterestMsg, style: boldTextStyle(size: 20)),
                      4.height,
                      Text(languages.chooseInterestMsg1, style: secondaryTextStyle(size: 14)),
                      30.height,
                      AnimationLimiter(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(catResponse!.length, (i) {
                            return AnimationConfiguration.staggeredGrid(
                              position: i,
                              columnCount: 2,
                              duration: Duration(milliseconds: 600),
                              child: FlipAnimation(
                                duration: Duration(milliseconds: 600),
                                flipAxis: FlipAxis.y,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    cachedImage(catResponse![i].image.toString(), height: 150, width: (context.width() - 44) * 0.5, fit: BoxFit.fill).cornerRadiusWithClipRRect(defaultRadius),
                                    Container(
                                      alignment: Alignment.center,
                                      width: (context.width() - 44) * 0.5,
                                      height: 150,
                                      decoration: boxDecorationWithRoundedCornersWidget(
                                          borderRadius: radius(),
                                          border: Border.all(
                                              width: 2,
                                              color: getStringListAsync(chooseTopicList) != null
                                                  ? getStringListAsync(chooseTopicList)!.contains(catResponse![i].id!.toString())
                                                      ? primaryColor
                                                      : context.dividerColor
                                                  : primaryColor),
                                          backgroundColor: getStringListAsync(chooseTopicList) != null ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.5)),
                                      child: Text(catResponse![i].name.toString(), style: boldTextStyle(size: 18, color: Colors.white)),
                                    ).onTap(() {
                                      if (getStringListAsync(chooseTopicList) != null) {
                                        selectedId = getStringListAsync(chooseTopicList)!;
                                        if (selectedId.contains(catResponse![i].id!.toString()) == true) {
                                          selectedId.remove(catResponse![i].id!.toString());
                                        } else
                                          selectedId.add(catResponse![i].id!.toString());
                                        setValue(chooseTopicList, selectedId);
                                      } else {
                                        selectedId.add(catResponse![i].id!.toString());
                                        setValue(chooseTopicList, selectedId);
                                      }
                                      setState(() {});
                                    }),
                                    getStringListAsync(chooseTopicList) != null
                                        ? getStringListAsync(chooseTopicList)!.contains(catResponse![i].id!.toString())
                                            ? Icon(Icons.check_circle, color: primaryColor).paddingAll(4)
                                            : SizedBox()
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                appButton(context, text: languages.lblConfirm, bgColor: primaryColor, onTap: () {
                  if (getStringListAsync(chooseTopicList) != null && getStringListAsync(chooseTopicList)!.length.toInt() >= 3) {
                    setValue(IS_FIRST_TIME, false);
                    DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                  } else {
                    toast(languages.lblConfirmCategory);
                  }
                }).paddingAll(16),
              ],
            ),
          ).paddingTop(widget.isSetting == true ? 0 : context.statusBarHeight + 16),
          mProgress().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
