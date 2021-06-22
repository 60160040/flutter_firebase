import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/model/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Student myStudent = Student();

  // เตรียม Firebase
  final Future <FirebaseApp> firebase =  Firebase.initializeApp();
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              appBar: AppBar(
                title: Text("แบบฟอร์มบันทึกคะแนนสอบ"),
              ),
              body: Container(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ชื่อ",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "กรุณาป้อนชื่อด้วยครับ T T"),
                          onSaved: (String? fname) {
                            myStudent.fname = fname;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "นามสกุล",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "กรุณาป้อนนามสกุล"),
                          onSaved: (String? lname) {
                            myStudent.lname = lname;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "อีเมล",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(errorText: "ป้อน email สิ"),
                            EmailValidator(errorText: "email รูปแบบไม่ถูกต้อง"),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (String? email) {
                            myStudent.email = email;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "คะแนน",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: RequiredValidator(errorText: "คะแนนด้วย"),
                          onSaved: (String? score) {
                            myStudent.score = score;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async{
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await _studentCollection.add({
                                  "fname":myStudent.fname,
                                  "lname":myStudent.lname,
                                  "email":myStudent.email,
                                  "score":myStudent.score,
                                });
                                formKey.currentState?.reset();
                              }
                            },
                            child: Text(
                              "บันทึกข้อมูล",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

  }
}
