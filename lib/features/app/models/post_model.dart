class PostModel {
  final String id;
  final String title;
  final String desc;
  final String domain;
  final String location;
  final String imageUrl;
  final SubmittedBy submittedBy;
  final List<String> upvotes;
  final List<String> downvotes;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final String status;

  PostModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.domain,
    required this.location,
    required this.imageUrl,
    required this.submittedBy,
    required this.upvotes,
    required this.downvotes,
    required this.comments,
    required this.createdAt,
    required this.status,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      domain: json['domain'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageurl'] ?? '',
      submittedBy: SubmittedBy.fromJson(json['submittedBy']),
      upvotes: List<String>.from(json['upvotes'] ?? []),
      downvotes: List<String>.from(json['downvotes'] ?? []),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((c) => CommentModel.fromJson(c))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "desc": desc,
      "domain": domain,
      "location": location,
      "imageurl": imageUrl,
      "submittedBy": submittedBy.toJson(),
      "upvotes": upvotes,
      "downvotes": downvotes,
      "comments": comments.map((c) => c.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
      "status": status,
    };
  }
}

class SubmittedBy {
  final String userId;
  final String name;

  SubmittedBy({required this.userId, required this.name});

  factory SubmittedBy.fromJson(Map<String, dynamic> json) {
    return SubmittedBy(userId: json['userId'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"userId": userId, "name": name};
  }
}

class CommentModel {
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "username": username,
      "text": text,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
