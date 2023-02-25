// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import 'package:vibe_music/Models/Album.dart';
import 'package:vibe_music/Models/Artist.dart';
import 'package:vibe_music/Models/Thumbnail.dart';

class Track {
  String title;
  String videoId;
  List<Thumbnail> thumbnails;
  List<Artist> artists;
  Album? albums;
  String? path;
  String? art;
  ColorPalette? colorPalette;
  Track({
    required this.title,
    required this.videoId,
    required this.thumbnails,
    required this.artists,
    this.albums,
    this.path,
    this.art,
    this.colorPalette,
  });

  Track copyWith({
    String? title,
    String? videoId,
    List<Thumbnail>? thumbnails,
    List<Artist>? artists,
    Album? albums,
    String? path,
    String? art,
    ColorPalette? colorPalette,
  }) {
    return Track(
      title: title ?? this.title,
      videoId: videoId ?? this.videoId,
      thumbnails: thumbnails ?? this.thumbnails,
      artists: artists ?? this.artists,
      albums: albums ?? this.albums,
      path: path ?? this.path,
      art: art ?? this.art,
      colorPalette: colorPalette ?? this.colorPalette,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'videoId': videoId,
      'thumbnails': thumbnails.map((x) => x.toMap()).toList(),
      'artists': artists.map((x) => x.toMap()).toList(),
      'albums': albums?.toMap(),
      'path': path,
      'art': art,
      'colorPalette': colorPalette?.toMap(),
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      title: map['title'] as String,
      videoId: map['videoId'] as String,
      thumbnails: List<Thumbnail>.from(
        (map['thumbnails'] as List).map<Thumbnail>(
          (x) => Thumbnail.fromMap(x as Map<String, dynamic>),
        ),
      ),
      artists: List<Artist>.from(
        (map['artists'] as List).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      albums: map['albums'] != null
          ? Album.fromMap(map['albums'] as Map<String, dynamic>)
          : null,
      colorPalette: ColorPalette.fromMap(map['colorPalette'] ?? {}),
      path: map['path'] != null ? map['path'] as String : null,
      art: map['art'] != null ? map['art'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(title: $title, videoId: $videoId, thumbnails: $thumbnails, artists: $artists, albums: $albums, path: $path, art: $art, colorPalette: $colorPalette)';
  }

  @override
  bool operator ==(covariant Track other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.videoId == videoId &&
        listEquals(other.thumbnails, thumbnails) &&
        listEquals(other.artists, artists) &&
        other.albums == albums &&
        other.path == path &&
        other.art == art &&
        other.colorPalette == colorPalette;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        videoId.hashCode ^
        thumbnails.hashCode ^
        artists.hashCode ^
        albums.hashCode ^
        path.hashCode ^
        art.hashCode ^
        colorPalette.hashCode;
  }
}

class ColorPalette {
  Color? darkMutedColor;
  Color? lightMutedColor;
  ColorPalette({
    this.darkMutedColor,
    this.lightMutedColor,
  });

  ColorPalette copyWith({
    Color? darkMutedColor,
    Color? lightMutedColor,
  }) {
    return ColorPalette(
      darkMutedColor: darkMutedColor ?? this.darkMutedColor,
      lightMutedColor: lightMutedColor ?? this.lightMutedColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'darkMutedColor': darkMutedColor?.value,
      'lightMutedColor': lightMutedColor?.value,
    };
  }

  factory ColorPalette.fromMap(Map<String, dynamic> map) {
    return ColorPalette(
      darkMutedColor: map['darkMutedColor'] != null
          ? Color(map['darkMutedColor'] as int)
          : null,
      lightMutedColor: map['lightMutedColor'] != null
          ? Color(map['lightMutedColor'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorPalette.fromJson(String source) =>
      ColorPalette.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ColorPalette(darkMutedColor: $darkMutedColor, lightMutedColor: $lightMutedColor)';

  @override
  bool operator ==(covariant ColorPalette other) {
    if (identical(this, other)) return true;

    return other.darkMutedColor == darkMutedColor &&
        other.lightMutedColor == lightMutedColor;
  }

  @override
  int get hashCode => darkMutedColor.hashCode ^ lightMutedColor.hashCode;
}
