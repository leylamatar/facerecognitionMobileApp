import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class showstudentPage extends StatefulWidget {
  const showstudentPage({super.key});

  @override
  State<showstudentPage> createState() => _showstudentPageState();
}

class _showstudentPageState extends State<showstudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 14, 56, 90),
        title: Text("Student List"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('faces').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            "${snapshot.data?.docs[index]['Profile Picture']}",
                            height: 110,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "Student Name :${snapshot.data?.docs[index]['name']} "),
                        Text("Student ID: ${snapshot.data?.docs[index]['id']}"),
                        //Text(
                           // "Student Email : ${snapshot.data?.docs[index]['Email']}"),

                        // Text(snapshot.data?.docs[index]['id']),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
