import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/shared_pref.dart';
import 'package:mighty_meditation/utils/Extensions/text_styles.dart';
import 'package:mighty_meditation/utils/constant.dart';
import 'package:mighty_meditation/utils/images.dart';
import '../main.dart';
import '../model/WalkThroughModel.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/colors.dart';
import 'ChooseInterest.dart';

class GetStartedScreen extends StatefulWidget {
  static String tag = '/GetStartedScreen';

  @override
  GetStartedScreenState createState() => GetStartedScreenState();
}

class GetStartedScreenState extends State<GetStartedScreen> {
  int? currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  List<WalkThroughModel> walkThroughClass = [
    WalkThroughModel(text: languages.lblWalk1Desc, name: languages.lblWalk1, img: ic_walk1),
    WalkThroughModel(text: languages.lblWalk2Desc, name: languages.lblWalk2, img: ic_walk2),
    WalkThroughModel(text: languages.lblWalk3Desc, name: languages.lblWalk3, img: ic_walk3)
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            child: PageView.builder(
              itemCount: walkThroughClass.length,
              controller: pageController,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    Image.asset(walkThroughClass[i].img.toString(), width: context.width(), height: context.height(), fit: BoxFit.cover),
                    Container(height: context.height(), color: Colors.black.withOpacity(0.4)),
                  ],
                );
              },
              onPageChanged: (int i) {
                currentIndex = i;
                setState(() {});
              },
            ),
          ),
          Positioned(
              right: 0,
              top: 36,
              child: TextButton(
                  child: Text(languages.lblSkip, style: boldTextStyle(color: whiteColor)),
                  onPressed: () {
                    setValue(IS_FIRST_TIME, true);
                    ChooseInterest().launch(context);
                  })),
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(walkThroughClass[currentIndex!.toInt()].name.toString(), style: boldTextStyle(color: whiteColor, size: 20), textAlign: TextAlign.center).paddingSymmetric(horizontal: 16),
                16.height,
                Text(walkThroughClass[currentIndex!.toInt()].text.toString(), style: secondaryTextStyle(size: 14, color: whiteColor.withOpacity(0.6)), textAlign: TextAlign.center)
                    .paddingSymmetric(horizontal: 16),
                16.height,
                dotIndicator(walkThroughClass, currentIndex),
                32.height,
                Container(
                  height: 42,
                  decoration: boxDecorationWithRoundedCornersWidget(borderRadius: radius(30), backgroundColor: primaryColor),
                  child: MaterialButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentIndex!.toInt() >= 2 ? languages.lblGetStarted : languages.lblNext, style: primaryTextStyle(color: whiteColor)),
                        8.width,
                        Icon(MaterialCommunityIcons.arrow_right_drop_circle_outline, color: Colors.white),
                      ],
                    ),
                    onPressed: () {
                      if (currentIndex!.toInt() >= 2) {
                        setValue(IS_FIRST_TIME, true);

                        ChooseInterest().launch(context);
                      } else {
                        pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.linearToEaseOut);
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
