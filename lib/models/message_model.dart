class MessageModel {
  String? receiverId;
  String? senderId;
  String? dateTime;
  String? text;


  MessageModel({
    required this.text,
    required this.dateTime,
    required this.receiverId,
    required this.senderId,
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    text=json['text'];
    dateTime=json['dateTime'];
    receiverId=json['receiverId'];
    senderId=json['senderId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'text':text,
      'dateTime': dateTime,
      'receiverId': receiverId,
      'senderId' : senderId,
    };
  }
}
