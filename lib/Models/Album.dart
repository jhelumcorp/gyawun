import 'dart:convert';

class Album {
  String name;
  String id;
  Album({
    required this.name,
    required this.id,
  });

  Album copyWith({
    String? name,
    String? id,
  }) {
    return Album(
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

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Album(name: $name, id: $id)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
