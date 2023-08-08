import 'package:mighty_meditation/utils/Extensions/Constants.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/decorations.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import 'package:flutter/material.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/text_styles.dart';

class CategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final Category data;
  final Function? onTap;
  final bool? isDashboard;

  CategoryItemWidget(this.data, {this.onTap, this.isDashboard = false});

  @override
  CategoryItemWidgetState createState() => CategoryItemWidgetState();
}

class CategoryItemWidgetState extends State<CategoryItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double w = !widget.isDashboard! ? (context.width() - 32) / 2 : (context.width() - 40) / 2;

    return GestureDetector(
      onTap: () {
        widget.onTap!.call();
        setState(() {});
      },
      child: !widget.isDashboard!
          ? Column(
              children: [
                if (widget.data.image != null && widget.data.image!.isNotEmpty) cachedImage(widget.data.image, height: 160, width: (context.width() - 48) / 2, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, style: boldTextStyle()).paddingAll(8),
              ],
            ).paddingBottom(8)
          : Container(
              width: w,
              decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), borderRadius: radius(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.data.image != null && widget.data.image!.isNotEmpty) cachedImage(widget.data.image, height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
                  ).expand(),
                ],
              ),
            ),
    );
  }
}
