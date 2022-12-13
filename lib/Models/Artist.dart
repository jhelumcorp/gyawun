// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Artist {
  String name;
  String? id;
  Artist({
    required this.name,
    this.id,
  });

  Artist copyWith({
    String? name,
    String? id,
  }) {
    return Artist(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      name: map['name'] as String,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(name: $name, id: $id)';

  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
