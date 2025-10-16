import 'dart:convert';

class Order {
  int? id;
  String clientName;
  String description;
  String status;
  List<String> materials;
  List<Map<String, String>> photos; // {path, caption}
  String? signaturePath;
  DateTime createdAt;

  Order({
    this.id,
    required this.clientName,
    required this.description,
    required this.status,
    required this.materials,
    required this.photos,
    this.signaturePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'description': description,
      'status': status,
      // garante que nunca salva null
      'materials': jsonEncode(materials),
      'photos': jsonEncode(photos),
      'signaturePath': signaturePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int?,
      clientName: map['clientName'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      materials: map['materials'] != null && map['materials'].toString().isNotEmpty
          ? List<String>.from(jsonDecode(map['materials']))
          : [],
      photos: map['photos'] != null && map['photos'].toString().isNotEmpty
          ? List<Map<String, String>>.from(
        (jsonDecode(map['photos']) as List).map(
              (e) => Map<String, String>.from(e),
        ),
      )
          : [],
      signaturePath: map['signaturePath'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}