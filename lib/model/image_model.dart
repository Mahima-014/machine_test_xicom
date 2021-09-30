class ImageModel {
  String status;
  List<Images> images;

  ImageModel({this.status, this.images});

  ImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String xtImage;
  String id;

  Images({this.xtImage, this.id});

  Images.fromJson(Map<String, dynamic> json) {
    xtImage = json['xt_image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xt_image'] = this.xtImage;
    data['id'] = this.id;
    return data;
  }
}