// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  late final _$isDarkModeOnAtom =
      Atom(name: '_AppStore.isDarkModeOn', context: context);

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  late final _$isNotificationOnAtom =
      Atom(name: '_AppStore.isNotificationOn', context: context);

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  late final _$isPlayAtom = Atom(name: '_AppStore.isPlay', context: context);

  @override
  bool get isPlay {
    _$isPlayAtom.reportRead();
    return super.isPlay;
  }

  @override
  set isPlay(bool value) {
    _$isPlayAtom.reportWrite(value, super.isPlay, () {
      super.isPlay = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$playListAtom =
      Atom(name: '_AppStore.playList', context: context);

  @override
  List<Category> get playList {
    _$playListAtom.reportRead();
    return super.playList;
  }

  @override
  set playList(List<Category> value) {
    _$playListAtom.reportWrite(value, super.playList, () {
      super.playList = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$clearPlayListAsyncAction =
      AsyncAction('_AppStore.clearPlayList', context: context);

  @override
  Future<void> clearPlayList() {
    return _$clearPlayListAsyncAction.run(() => super.clearPlayList());
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String aCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aCode, context: context));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void addPlayListItem(Category productList) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.addPlayListItem');
    try {
      return super.addPlayListItem(productList);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlay(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setPlay');
    try {
      return super.setPlay(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkModeOn: ${isDarkModeOn},
isNotificationOn: ${isNotificationOn},
isPlay: ${isPlay},
isLoading: ${isLoading},
playList: ${playList},
selectedLanguageCode: ${selectedLanguageCode}
    ''';
  }
}
