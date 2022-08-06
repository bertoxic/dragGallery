class imageModel {
  String? id;
  String? title;
  String? image;
  int? order;

  imageModel({this.id, this.title, this.image, this.order});

  imageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['order'] = this.order;
    return data;
  }
}