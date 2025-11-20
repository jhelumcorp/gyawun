class YTConfig {
  YTConfig({
    required this.visitorData,
    required this.language,
    required this.location,
  });
  String visitorData;
  String language;
  String location;

  YTConfig copyWith({
    String? visitorData,
    String? language,
    String? location,
  }) =>
      YTConfig(
        visitorData: visitorData ?? this.visitorData,
        language: language ?? this.language,
        location: location ?? this.location,
      );
}
