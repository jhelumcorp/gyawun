class YtMusicLocation {
  YtMusicLocation({required this.title, required this.value});

  factory YtMusicLocation.fromJson(Map<String, dynamic> json) =>
      YtMusicLocation(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}
