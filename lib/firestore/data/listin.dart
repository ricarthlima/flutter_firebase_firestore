class Listin {
  String id;
  String name;

  Listin({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}
