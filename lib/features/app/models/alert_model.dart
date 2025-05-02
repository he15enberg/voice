class AlertModel {
  String id;
  String title;
  String message;
  String type; // info, success, warning, error
  DateTime createdAt;
  DateTime updatedAt;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Empty helper
  static AlertModel empty() => AlertModel(
    id: "",
    title: "",
    message: "",
    type: "info",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "message": message,
      "type": type,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> data) {
    return AlertModel(
      id: data["_id"],
      title: data["title"] ?? '',
      message: data["message"] ?? '',
      type: data["type"] ?? 'info',
      createdAt: DateTime.tryParse(data["createdAt"] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(data["updatedAt"] ?? '') ?? DateTime.now(),
    );
  }
}
