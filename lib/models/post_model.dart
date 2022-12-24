class PostModel {
   String? name;
   String? uId;
   String? image;
   String? dateTime;
   String? text;
   String? postImage;

  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    required this.dateTime,
    required this.text,
    required this.postImage,

  });

  PostModel.fromJson(Map<String,dynamic> json){
    name=json['name'];
    uId=json['uId'];
    dateTime=json['dateTime'];
    image=json['image'];
    text=json['text'];
    postImage=json['postImage'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'uId' : uId,
      'dateTime': dateTime,
      'image' :image,
      'text' : text,
      'postImage' : postImage,
    };
  }
}
