

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:we_story/responsive.dart';

import 'UserDataProvider.dart';
import 'constants.dart';
class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var storyController=TextEditingController();
  var _shortController=TextEditingController();
  var longController=TextEditingController();
  Future<void> _showAddStoryDialog() async {
    String imageUrl="";
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    bool imageUploading=false;
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            uploadToFirebase(File imageFile) async {
              final filePath = 'images/${DateTime.now()}.png';
              print("put");
              setState((){
                imageUploading=true;
                _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
              });
              fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
              imageUri = await taskSnapshot.ref.getDownloadURL();
              setState((){
                imageUrl=imageUri.toString();
                imageUploading=false;
                print(imageUrl);
              });
            }

            pickFiles()async{
              var imageFile = await ImagePickerWeb.getMultiImagesAsFile();
              if(imageFile!=null)
                uploadToFirebase(imageFile.first);
            }

            uploadImage() async {
              FileUploadInputElement uploadInput = FileUploadInputElement();
              uploadInput.click();
              uploadInput.onChange.listen(
                    (changeEvent) {
                  final file = uploadInput.files!.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(file);
                  reader.onLoadEnd.listen(
                        (loadEndEvent) async {
                      uploadToFirebase(file);
                    },
                  );
                  reader.onError.listen((fileEvent) {
                    setState(() {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Unable to load image",
                      );
                    });
                  });
                },
              );
            }
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                width: Responsive.isDesktop(context)?MediaQuery.of(context).size.width*0.5:Responsive.isTablet(context)?MediaQuery.of(context).size.width*0.7:MediaQuery.of(context).size.width*0.8,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Add Story",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6!.apply(color: secondaryColor),),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.close,color: Colors.grey,),
                                onPressed: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                          ),
                          TextFormField(
                            controller: storyController,
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                          ),
                          TextFormField(
                            minLines: 10,
                            maxLines: 10,
                            controller: _shortController,
                            style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          pickFiles();
                        },
                        child: Container(
                          height: 200,
                          child: imageUploading?Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Uploading",style: TextStyle(color: primaryColor),),
                                SizedBox(width: 10,),
                                CircularProgressIndicator()
                              ],),
                          ):imageUrl==""?
                          Container(
                            margin: EdgeInsets.all(10),
                            color: Colors.white,
                            child: DottedBorder(
                                color: primaryColor,
                                strokeWidth: 1,
                                dashPattern: [7],
                                borderType: BorderType.Rect,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/upload.png",color: primaryColor,height: 50,width: 50,fit: BoxFit.cover,),
                                      SizedBox(height: 10,),
                                      Text("Select Image",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w300),)
                                    ],
                                  ),
                                )
                            ),
                          )

                              :Image.network(imageUrl,height: 200,fit: BoxFit.cover,),
                        ),
                      ),

                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          print("rr");
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Adding");
                          FirebaseFirestore.instance.collection('stories').add({
                            'story': _shortController.text,
                            'title': storyController.text,
                            'image': imageUrl,
                            'userId':FirebaseAuth.instance.currentUser!.uid,
                            'username':"${provider.userData!.firstName} ${provider.userData!.lastName}",
                            'time':DateTime.now().millisecondsSinceEpoch
                          }).then((value) {
                            pr.close();
                            print("added");
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 50,
                          color: primaryColor,
                          alignment: Alignment.center,
                          child: Text("Post",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width*0.1,
        right: MediaQuery.of(context).size.height*0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.2, color: Colors.grey),
        ),
      ),
      height: MediaQuery.of(context).size.height*0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/logo.png",height: 40,),
          Row(
            children: [
              InkWell(
                onTap: (){
                  _showAddStoryDialog();
                },
                child: Image.asset("assets/more.png",height: 20,)
              ),
              SizedBox(width: 20,),
              Text("${provider.userData!.firstName} ${provider.userData!.lastName}"),
            ],
          )
        ],
      ),
    );
  }
}
