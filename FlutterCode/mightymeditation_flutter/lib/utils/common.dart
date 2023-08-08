import '../model/LanguageDataModel.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/Flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/Flag/ic_in.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/Flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', subTitle: 'français', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/Flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'Portuguese', subTitle: 'português', languageCode: 'pt', fullLanguageCode: 'pt-PT', flag: 'assets/Flag/ic_pt.png'),
    LanguageDataModel(id: 6, name: 'Turkish', subTitle: 'Türk', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'assets/Flag/ic_tr.png'),
    LanguageDataModel(id: 7, name: 'Afrikaans', subTitle: 'Afrikaans', languageCode: 'af', fullLanguageCode: 'af-AF', flag: 'assets/Flag/ic_af.png'),
    LanguageDataModel(id: 8, name: 'Vietnamese', subTitle: 'Tiếng Việt', languageCode: 'vi', fullLanguageCode: 'vi-VI', flag: 'assets/Flag/ic_vi.png'),
  ];
}
