class Folder {
  int? id;
  String name;

  Folder({this.id, required this.name});

  factory Folder.fromMap(Map<String, dynamic> json) => Folder(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
