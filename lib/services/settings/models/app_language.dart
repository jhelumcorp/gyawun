class AppLanguage {
  AppLanguage({required this.title, required this.value});

  factory AppLanguage.fromJson(Map<String, dynamic> json) =>
      AppLanguage(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}
