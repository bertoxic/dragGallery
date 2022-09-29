
class ParentModel {
   ParentModel({this.classId,this.listz});
   String? classId;
   List<ImageModel>? listz=[];

   ParentModel.fromJson(Map<String ,dynamic> json){
      classId = json["classId"];

      if (json["listz"] !=null){
         listz=[];
         for (var item in json["listz"]){
           listz?.add(ImageModel.fromJson(item));
         }
      }
   }
    Map<String,dynamic> toJson(){
      final Map<String, dynamic> data =  <String, dynamic>{};
      data["classId"]=classId;
      if (listz!=null){
         List dat=[];
         for (var item in listz!){
            dat.add(item.toJson());
         }
         data["listz"]=dat;

      }
      return data;
   }
}

class ImageModel {
   String? id;
   String? title;
   String? image;
   int? order;
   bool? isAssets;


   ImageModel({this.id, this.title, this.image, this.order,this.isAssets=false});

   ImageModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      title = json['title'];
      image = json['image'];
      order = json['order'];
      isAssets = json['isAssets'];
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data =  Map<String, dynamic>();
      data['id'] = this.id;
      data['title'] = this.title;
      data['image'] = this.image;
      data['order'] = this.order;
      data['isAssets'] = this.isAssets;
      return data;
   }
}