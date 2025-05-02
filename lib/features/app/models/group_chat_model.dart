import 'package:voice/features/app/models/post_model.dart';

class GroupChatModel {
  final String id;
  final String name;
  final PostGroupModel? postGroup;
  final List<MemberModel> members;
  final List<MessageModel>? messages; // made nullable
  final DateTime createdAt;

  GroupChatModel({
    required this.id,
    required this.name,
    required this.postGroup,
    required this.members,
    required this.messages,
    required this.createdAt,
  });

  static GroupChatModel empty() => GroupChatModel(
    id: '',
    name: '',
    postGroup: null,
    members: [],
    messages: null,
    createdAt: DateTime.now(),
  );

  factory GroupChatModel.fromJson(Map<String, dynamic> json) {
    return GroupChatModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      postGroup:
          json['postGroup'] != null
              ? PostGroupModel.fromJson(json['postGroup'])
              : null,
      members:
          (json['members'] as List<dynamic>?)
              ?.map((m) => MemberModel.fromJson(m))
              .toList() ??
          [],
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((m) => MessageModel.fromJson(m))
              .toList(), // can be null
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "postGroup": postGroup?.toJson(),
      "members": members.map((m) => m.toJson()).toList(),
      "messages": messages?.map((m) => m.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
    };
  }
}

class PostGroupModel {
  final String id;
  final List<String> similarQueries;
  final String domain;
  final String location;
  final List<PostModel>? posts;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostGroupModel({
    required this.id,
    required this.similarQueries,
    required this.domain,
    required this.location,
    required this.posts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostGroupModel.fromJson(Map<String, dynamic> json) {
    return PostGroupModel(
      id: json['_id'] ?? '',
      similarQueries: List<String>.from(json['similarQueries'] ?? []),
      domain: json['domain'] ?? '',
      location: json['location'] ?? '',
      posts:
          (json['posts'] as List<dynamic>? ?? [])
              .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "similarQueries": similarQueries,
      "domain": domain,
      "location": location,
      "posts": posts,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class MemberModel {
  final String id;
  final String name;

  MemberModel({required this.id, required this.name});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(id: json['_id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name};
  }
}

class MessageModel {
  final User? user;
  final String message;
  final String role;
  final String type;
  final PostModel? post;
  final DateTime createdAt;

  MessageModel({
    required this.user,
    required this.message,
    required this.role,
    required this.type,
    this.post,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      message: json['message'] ?? '',
      role: json['role'] ?? '',
      type: json['type'] ?? '',
      post: json['post'] != null ? PostModel.fromJson(json['post']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": user?.toJson(),
      "message": message,
      "role": role,
      "type": type,
      "post": post?.toJson(),
      "createdAt": createdAt.toIso8601String(),
    };
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name};
  }
}
