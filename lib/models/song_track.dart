// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gyawun/api/image_resolution_modifier.dart';

import 'package:gyawun/models/album_model.dart';

class SongTrack {
  String id;
  int? year;
  int? duration;
  String language;
  String genre;
  bool hasLyrics;
  Album album;
  String subtitle;
  String title;
  String artist;
  List<String> images;
  String url;
  bool offline;
  SongTrack({
    required this.id,
    this.year,
    this.duration,
    required this.language,
    required this.genre,
    required this.hasLyrics,
    required this.album,
    required this.subtitle,
    required this.title,
    required this.artist,
    required this.images,
    required this.url,
    required this.offline,
  });

  SongTrack copyWith({
    String? id,
    int? year,
    int? duration,
    String? language,
    String? genre,
    bool? hasLyrics,
    Album? album,
    String? subtitle,
    String? title,
    String? artist,
    List<String>? images,
    String? url,
    bool? offline,
  }) {
    return SongTrack(
      id: id ?? this.id,
      year: year ?? this.year,
      duration: duration ?? this.duration,
      language: language ?? this.language,
      genre: genre ?? this.genre,
      hasLyrics: hasLyrics ?? this.hasLyrics,
      album: album ?? this.album,
      subtitle: subtitle ?? this.subtitle,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      images: images ?? this.images,
      url: url ?? this.url,
      offline: offline ?? this.offline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'duration': duration,
      'language': language,
      'genre': genre,
      'hasLyrics': hasLyrics,
      'album': album.toMap(),
      'subtitle': subtitle,
      'title': title,
      'artist': artist,
      'images': images,
      'url': url,
      'offline': offline,
    };
  }

  factory SongTrack.fromMap(Map<String, dynamic> map) {
    return SongTrack(
      id: map['id'] as String,
      year: map['year'] != null ? int.parse(map['year']) : null,
      duration: map['duration'] != null ? int.parse(map['duration']) : null,
      language: map['language'] as String,
      genre: map['genre'] as String,
      hasLyrics: bool.parse(map['has_lyrics']),
      album: Album(id: map['album_id'], title: map['album'], artists: []),
      subtitle: map['subtitle'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      images: [
        getImageUrl(map['image'], quality: 'low'),
        getImageUrl(map['image'], quality: 'medium'),
        getImageUrl(map['image'], quality: 'high')
      ],
      url: map['url'] as String,
      offline: map['offline'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongTrack.fromJson(String source) =>
      SongTrack.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongTrack(id: $id, year: $year, duration: $duration, language: $language, genre: $genre, hasLyrics: $hasLyrics, album: $album, subtitle: $subtitle, title: $title, artist: $artist, images: $images, url: $url, offline: $offline)';
  }

  @override
  bool operator ==(covariant SongTrack other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.year == year &&
        other.duration == duration &&
        other.language == language &&
        other.genre == genre &&
        other.hasLyrics == hasLyrics &&
        other.album == album &&
        other.subtitle == subtitle &&
        other.title == title &&
        other.artist == artist &&
        listEquals(other.images, images) &&
        other.url == url &&
        other.offline == offline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        year.hashCode ^
        duration.hashCode ^
        language.hashCode ^
        genre.hashCode ^
        hasLyrics.hashCode ^
        album.hashCode ^
        subtitle.hashCode ^
        title.hashCode ^
        artist.hashCode ^
        images.hashCode ^
        url.hashCode ^
        offline.hashCode;
  }
}
