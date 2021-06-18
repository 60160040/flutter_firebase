import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายงานคะแนนสอบ"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView(
            children: snapshot.data.docs.map((document){

            }).toList(),
          );
        },
      ),
    );
  }
}
