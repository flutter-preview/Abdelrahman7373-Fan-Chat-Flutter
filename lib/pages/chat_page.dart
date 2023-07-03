import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_chat/components/chat_bubble.dart';
import 'package:fan_chat/components/chat_text_field.dart';
import 'package:fan_chat/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({super.key, required this.receiverUserId, required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();







  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }






  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserId, _messageController.text);
      _messageController.clear();
      scrollToBottom();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          _buildMessageInput(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {return Text('Error${snapshot.error}');}
        if(snapshot.connectionState == ConnectionState.waiting){return Center(child: SpinKitFadingCube(color: Colors.blue, size: 50.0,));}

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ListView(
          controller: _scrollController, children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }



  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data=document.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail'],),
            const SizedBox(height: 10,),
            ChatBubble(message: data['message'],isCurrentUser: isCurrentUser,),
          ],
        ),
      ),
    );
  }


  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(child: ChatTextField(controller: _messageController, hintText: 'Send A Message...',),),
          GestureDetector(onTap: sendMessage, child: Image.asset('assets/arrow_up.png', width: 55, height: 55,))
        ],
      ),
    );
  }
}