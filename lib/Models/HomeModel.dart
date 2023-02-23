import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  String title;
  List playlists;

  HomeModel({
    required this.title,
    required this.playlists,
  });

  String get getTitle => title;
  List get getPlaylist => playlists;

  set setTitle(String title) => this.title = title;
  set setPlaylist(List playlists) => this.playlists = playlists;

  HomeModel copyWith({
    String? title,
    List? playlists,
  }) {
    return HomeModel(
      title: title ?? this.title,
      playlists: playlists ?? this.playlists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'playlist': playlists,
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      title: map['title'] as String,
      playlists: List.from(
        (map['playlist'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HomeModel(title: $title, playlist: $playlists)';

  @override
  bool operator ==(covariant HomeModel other) {
    if (identical(this, other)) return true;

    return other.title == title && listEquals(other.playlists, playlists);
  }

  @override
  int get hashCode => title.hashCode ^ playlists.hashCode;
}
