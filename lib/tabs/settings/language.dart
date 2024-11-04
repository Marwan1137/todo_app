class Language {
  final String name;
  final String code;

  Language({required this.name, required this.code});

  static List<Language> languageList() {
    return <Language>[
      Language(name: 'English', code: 'en'),
      Language(name: 'العربية', code: 'ar'),
    ];
  }
}
