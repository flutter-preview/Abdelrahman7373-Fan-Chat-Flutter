import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fan_chat/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void signOut()  {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){return const Text('error');}
        if(snapshot.connectionState == ConnectionState.waiting){return Center(child: SpinKitFadingCube(color: Colors.blue, size: 50.0,));}

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      bool isUserOnline = Random().nextBool();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3),spreadRadius: 2,blurRadius: 5,offset: Offset(0, 3),),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.cyan[100],
            child: Text(
              data['email'][0].toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,),
            ),
          ),
          title: Text(
            data['email'],
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
          subtitle: Text(isUserOnline ? 'Online' : 'Offline',style: TextStyle(color: Colors.grey,),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(receiverUserEmail: data['email'],receiverUserId: data['uid'],),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}