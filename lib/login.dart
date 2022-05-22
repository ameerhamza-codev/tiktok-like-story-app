import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:we_story/register.dart';
import 'package:we_story/responsive.dart';
import 'package:we_story/users.dart';

import 'UserDataProvider.dart';
import 'constants.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _emailController=TextEditingController();
  var _passwordController=TextEditingController();
  bool obscure=true;


  @override
  void initState() {
    super.initState();
    _emailController.text="anajam55@gmail.com";
    _passwordController.text="password";
  }

  login()async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Logging In');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text
    ).then((value)async{
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          pr.close();
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
          final provider = Provider.of<UserDataProvider>(context, listen: false);
          provider.setUserData(user);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));



        }
        else{
          pr.close();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "No User Data",
          );
        }
      });

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherBar()));
    }).onError((error, stackTrace){
      pr.close();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: error.toString(),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(Responsive.isMobile(context))
            Container(
              color: Colors.white,
              child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: buildEmailFormField(),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: buildPasswordFormField(),
          ),
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () async{

                  if(_formKey.currentState!.validate()){
                    login();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,

                  height: 40,
                  child: Text('LOGIN',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
              ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Don\'t have an account?',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w300,fontSize: 15),),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () async{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register()));



                    },
                    child: Container(

                      child: Text('SIGN UP',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
                    ),
                  ),
                ],
              ),
          )
        ],
      ),
    ),
            )
          else if(Responsive.isDesktop(context) || Responsive.isTablet(context))
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.2,
                    right: MediaQuery.of(context).size.width*0.2
                  ),
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.6,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/thoughts.png"),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: buildEmailFormField(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: buildPasswordFormField(),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () async{

                                      if(_formKey.currentState!.validate()){
                                        login();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width*0.8,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      alignment: Alignment.center,

                                      height: 40,
                                      child: Text('LOGIN',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Don\'t have an account?',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w300,fontSize: 15),),
                                      SizedBox(width: 3),
                                      GestureDetector(
                                        onTap: () async{
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register()));



                                        },
                                        child: Container(

                                          child: Text('SIGN UP',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )

        ],
      ),
    );
  }



  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      controller: _passwordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0.5,
          ),
        ),
        filled: true,
        prefixIcon: Icon(Icons.lock_outline,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: 'Enter Password',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _emailController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0.5,
          ),
        ),
        filled: true,
        prefixIcon: Icon(Icons.alternate_email,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: 'Enter Email',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
