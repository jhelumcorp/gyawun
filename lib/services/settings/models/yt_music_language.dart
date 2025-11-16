class YtMusicLanguage {
  YtMusicLanguage({required this.title, required this.value});

  factory YtMusicLanguage.fromJson(Map<String, dynamic> json) =>
      YtMusicLanguage(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}
