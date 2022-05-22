import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_story/header.dart';
import 'package:we_story/responsive.dart';
import 'package:we_story/story.dart';

import 'UserDataProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _showDetailStoryDialog(StoryModel storyModel) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            final provider = Provider.of<UserDataProvider>(context, listen: false);

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
                width: MediaQuery.of(context).size.width*0.5,
                height: MediaQuery.of(context).size.height*0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                        ),
                        child: Image.network(
                          storyModel.image,fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:  Text(storyModel.username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              child:  Text(timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(storyModel.time).toString()),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child:  Text(storyModel.title,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w400),),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              child:  Text(storyModel.story,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w300),),
                            ),

                          ],
                        ),
                      )
                    )
                  ],
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
    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stories').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),

                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    StoryModel story=StoryModel.fromMap(data, document.reference.id);

                    return Container(
                      margin: EdgeInsets.only(bottom: 40),
                      width: Responsive.isMobile(context)?MediaQuery.of(context).size.width*0.9:MediaQuery.of(context).size.width*0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Responsive.isMobile(context)?MediaQuery.of(context).size.width*0.9:MediaQuery.of(context).size.width*0.7,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child:  Text(story.username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  child:  Text(timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(story.time).toString()),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),),
                                ),
                                SizedBox(height: 15,),
                                Container(
                                  child:  Text(story.title,style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),),
                                ),
                                SizedBox(height: 5,),
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Container(
                                      child:  Text(story.story.length<1000?story.story:story.story.substring(0,1000),style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),),
                                    ),
                                    SizedBox(width: 5,),
                                    if(story.story.length>=1000)
                                    Container(
                                      child:  InkWell(
                                        onTap: (){
                                          _showDetailStoryDialog(story);
                                        },
                                        child: Row(
                                          children: [
                                            Text("Read More",style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.blue),),
                                            SizedBox(width: 5,),
                                            Icon(Icons.arrow_forward_ios_sharp,color: Colors.blue,size: 15,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Image.network(
                            story.image,fit: BoxFit.cover,
                            width: Responsive.isMobile(context)?MediaQuery.of(context).size.width*0.9:MediaQuery.of(context).size.width*0.7,
                            height: MediaQuery.of(context).size.height*0.5,
                          )

                        ],

                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
