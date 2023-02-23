import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  String title;
  List playlist;

  HomeModel({
    required this.title,
    required this.playlist,
  });

  String get getTitle => title;
  List get getPlaylist => playlist;

  set setTitle(String title) => this.title = title;
  set setPlaylist(List playlist) => this.playlist = playlist;

  HomeModel copyWith({
    String? title,
    List? playlist,
  }) {
    return HomeModel(
      title: title ?? this.title,
      playlist: playlist ?? this.playlist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'playlist': playlist,
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      title: map['title'] as String,
      playlist: List.from(
        (map['playlist'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HomeModel(title: $title, playlist: $playlist)';

  @override
  bool operator ==(covariant HomeModel other) {
    if (identical(this, other)) return true;

    return other.title == title && listEquals(other.playlist, playlist);
  }

  @override
  int get hashCode => title.hashCode ^ playlist.hashCode;
}
