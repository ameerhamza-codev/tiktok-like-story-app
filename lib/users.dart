import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String userId,firstName,lastName,email,password;


  UserModel(
      this.userId, this.firstName, this.lastName, this.email, this.password);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : userId=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        password = map['password'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}