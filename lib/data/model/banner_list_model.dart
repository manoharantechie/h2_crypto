import 'dart:convert';

BannerImageListModel bannerImageListModelFromJson(String str) => BannerImageListModel.fromJson(json.decode(str));

String bannerImageListModelToJson(BannerImageListModel data) => json.encode(data.toJson());

class BannerImageListModel {
  BannerImageListModel({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  List<BannerImageList>? data;

  factory BannerImageListModel.fromJson(Map<String, dynamic> json) => BannerImageListModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: List<BannerImageList>.from(json["data"].map((x) => BannerImageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BannerImageList {
  BannerImageList({
    this.id,
    this.imagePath,
    this.imgUrl,
  });

  String? id;
  String? imagePath;
  String? imgUrl;

  factory BannerImageList.fromJson(Map<String, dynamic> json) => BannerImageList(
    id: json["_id"],
    imagePath: json["image_path"],
    imgUrl: json["imgUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image_path": imagePath,
    "imgUrl": imgUrl,
  };
}
