class Photographer {
  final String id;
  final String name;

  Photographer({required this.id, required this.name});

  factory Photographer.fromJson(Map<String, dynamic> json) {
    return Photographer(id: json['id'], name: json['name']);
  }
}
