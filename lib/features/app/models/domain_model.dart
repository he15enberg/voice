class DomainModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  DomainModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId = "",
    required this.isFeatured,
  });
  //Empty helper function
  static DomainModel empty() =>
      DomainModel(id: "", name: "", image: "", isFeatured: false);
  //Convert model tojson
  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Image": image,
      "ParentId": parentId,
      "IsFeatured": isFeatured,
    };
  }

  //Map json oriented document snapshot from firebase to model
  // factory DomainModel.fromSnaphot(
  //   DocumentSnapshot<Map<String, dynamic>> document,
  // ) {
  //   if (document.data() != null) {
  //     final data = document.data()!;

  //     return DomainModel(
  //       id: document.id,
  //       name: data["Name"] ?? "",
  //       image: data["Image"] ?? "",
  //       isFeatured: data["IsFeatured"] ?? false,
  //       parentId: data["ParentId"] ?? "",
  //     );
  //   } else {
  //     return DomainModel.empty();
  //   }
  // }
}
