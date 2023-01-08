// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Thumbnail {
  String url;
  int? width;
  int? height;
  Thumbnail({
    required this.url,
    this.width,
    this.height,
  });

  Thumbnail copyWith({
    String? url,
    int? width,
    int? height,
  }) {
    return Thumbnail(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'width': width,
      'height': height,
    };
  }

  factory Thumbnail.fromMap(Map<String, dynamic> map) {
    return Thumbnail(
      url: map['url'] as String,
      width: map['width'] != null ? map['width'] as int : null,
      height: map['height'] != null ? map['height'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Thumbnail.fromJson(String source) =>
      Thumbnail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Thumbnail(url: $url, width: $width, height: $height)';

  @override
  bool operator ==(covariant Thumbnail other) {
    if (identical(this, other)) return true;

    return other.url == url && other.width == width && other.height == height;
  }

  @override
  int get hashCode => url.hashCode ^ width.hashCode ^ height.hashCode;
}
