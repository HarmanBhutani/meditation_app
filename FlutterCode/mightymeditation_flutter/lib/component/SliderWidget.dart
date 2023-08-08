import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/Extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';

class SliderWidget extends StatefulWidget {
  static String tag = '/SliderWidget';
  final Function? onTap;
  final SliderResponse? data;

  SliderWidget({this.data, this.onTap});

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
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
    return GestureDetector(
      onTap: () {
        widget.onTap!.call();
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widget.data!.imageUrl != null && widget.data!.imageUrl!.isNotEmpty) cachedImage(widget.data!.imageUrl, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(widget.data!.title!, style: boldTextStyle(size: 20, color: Colors.white)),
          ),
        ],
      ).paddingSymmetric(horizontal: 12),
    );
  }
}
