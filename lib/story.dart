import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel{
  String id,username,story,title,short,image,userId;
  int time;


  

  StoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        username = map['username'],
        title = map['title']??"no title",
        short = map['short']??"this is a story",
        story = map['story'],
        image = map['image'],
        time = map['time'],
        userId = map['userId'];



  StoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}