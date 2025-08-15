class FeedbackModel {
  final String id;
  final String message;
  final String createdAt;
  final String updatedAt;
  final List<String> images;

  FeedbackModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      message: json['message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': images,
    };
  }
}
