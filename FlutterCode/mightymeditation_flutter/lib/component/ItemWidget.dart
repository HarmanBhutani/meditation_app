import 'package:mighty_meditation/utils/Extensions/Colors.dart';
import 'package:mighty_meditation/utils/Extensions/Commons.dart';
import 'package:mighty_meditation/utils/Extensions/Constants.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/Extensions/int_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:flutter/material.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';

class ItemWidget extends StatefulWidget {
  static String tag = '/ItemWidget';
  final Function? onTap;
  final bool? isFavourite;
  final bool? isGrid;
  final bool? isPopular;
  final Category data;

  ItemWidget(this.data, {this.onTap, this.isFavourite = false, this.isGrid = false, this.isPopular = false});

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> {
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

  @override
  Widget build(BuildContext context) {
    double w = widget.isGrid == true ? (context.width() - 44) / 2 : context.width() * 0.45;
    double h = widget.isGrid == true ? 150 : 150;
    return widget.isFavourite == false
        ? SizedBox(
            width: w,
            child: GestureDetector(
              onTap: () {
                widget.onTap!.call();
                setState(() {});
              },
              child: widget.data.image != null && widget.data.image!.isNotEmpty
                  ? Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        cachedImage(widget.data.image, fit: BoxFit.fill, width: w, height: h).cornerRadiusWithClipRRect(defaultRadius),
                        Container(
                          width: w,
                          height: h,
                          decoration: BoxDecoration(
                              borderRadius: radius(defaultRadius),
                              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                Colors.black26,
                                Colors.black26,
                                Colors.black26,
                              ])),
                        ),
                        Container(
                          width: w,
                          height: h,
                          decoration: BoxDecoration(
                              borderRadius: radius(defaultRadius),
                              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                transparentColor,
                                transparentColor,
                                primaryColor.withOpacity(0.6),
                              ])),
                        ),
                        Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, style: boldTextStyle(color: Colors.white)).paddingAll(8),
                      ],
                    ).paddingRight(widget.isGrid == true ? 0 : 4)
                  : SizedBox(),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: boxDecorationWithShadowWidget(borderRadius: radius(), blurRadius: 0, backgroundColor: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 85,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      if (widget.data.image != null && widget.data.image!.isNotEmpty) cachedImage(widget.data.image, height: 85, width: 85, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: boxDecorationWithRoundedCornersWidget(borderRadius: BorderRadius.only(topLeft: radiusCircular(), bottomRight: radiusCircular()), backgroundColor: primaryColor),
                        child: Text(widget.data.categoryName!, maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.name!, style: boldTextStyle()),
                      4.height,
                      Text(widget.data.description!, maxLines: 1, style: secondaryTextStyle()),
                    ],
                  ).paddingAll(8),
                )
              ],
            ),
          ).onTap(() {
            hideKeyboard(context);
            widget.onTap!.call();
            setState(() {});
          });
  }
}
