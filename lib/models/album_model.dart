// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:gyawun/models/artist_model.dart';

class Album {
  String id;
  String title;
  String? image;
  String? language;
  int? year;
  List<Artist> artists;
  Album({
    required this.id,
    required this.title,
    this.image,
    this.language,
    this.year,
    required this.artists,
  });

  Album copyWith({
    String? id,
    String? title,
    String? image,
    String? language,
    int? year,
    List<Artist>? artists,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      language: language ?? this.language,
      year: year ?? this.year,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image': image,
      'language': language,
      'year': year,
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as String,
      title: map['title'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      language: map['language'] != null ? map['language'] as String : null,
      year: map['year'] != null ? map['year'] as int : null,
      artists: List<Artist>.from(
        (map['artists'] as List<int>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Album(id: $id, title: $title, image: $image, language: $language, year: $year, artists: $artists)';
  }

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.image == image &&
        other.language == language &&
        other.year == year &&
        listEquals(other.artists, artists);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        image.hashCode ^
        language.hashCode ^
        year.hashCode ^
        artists.hashCode;
  }
}
