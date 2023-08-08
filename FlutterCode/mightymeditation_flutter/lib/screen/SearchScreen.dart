import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_meditation/component/ItemWidget.dart';
import 'package:mighty_meditation/model/DashboardResponse.dart';
import 'package:mighty_meditation/network/RestApis.dart';
import 'package:mighty_meditation/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_meditation/utils/appWidget.dart';
import '../main.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/constant.dart';
import 'AudioDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCont = TextEditingController();

  List<Category> mMeditationList = [];
  List<Category> searchList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    loadStation();
  }

  void loadStation() {
    appStore.setLoading(true);
    getMeditationData().then((value) {
      appStore.setLoading(false);
      setState(() {
        mMeditationList.clear();
        mMeditationList.addAll(value);
        searchList = mMeditationList;
      });
    }).catchError((e) {
      appStore.setLoading(false);
      log(e);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mBody() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              autoFocus: true,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context, label: languages.lblSearch, prefixIcon: Icon(Ionicons.search_outline)),
              controller: searchCont,
              onChanged: (v) async {
                setState(() {
                  searchList = mMeditationList.where((u) => (u.name!.toLowerCase().contains(v.toLowerCase()) || u.name!.toLowerCase().contains(v.toLowerCase()))).toList();
                });
              },
              suffix: InkWell(onTap: () {
                loadStation();
                searchCont.text='';
                setState(() {});
              },child: Icon(Icons.close)),
              onFieldSubmitted: (c) {
                // loadStation();
                // setState(() {});
                setState(() {
                  searchList = mMeditationList.where((u) => (u.name!.toLowerCase().contains(c.toLowerCase()) || u.name!.toLowerCase().contains(c.toLowerCase()))).toList();
                });
              },
            ).paddingAll(16),
            searchList.isEmpty && !appStore.isLoading
                ? noDataWidget(context).center()
                : ListView.builder(
                    itemCount: searchList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 16),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemWidget(searchList[index], isFavourite: true, onTap: () async {
                        AudioDetailScreen(data: searchList[index]).launch(context);
                      });
                    },
                  ).expand()
          ],
        ),
        mProgress().center().visible(appStore.isLoading)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(languages.lblSearch, showBack: false),
      body: mBody(),
      bottomNavigationBar: mSearchBannerAds == '1' ? showBannerAds() : SizedBox(),
    );
  }
}
