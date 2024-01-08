import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = FirebaseFirestore.instance;


class ChatScreen extends StatefulWidget {
  static const id = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final textController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        print(loggedInUser.emailVerified);
      }
    } catch(e) {
      print(e);
    }
  }


  void getMessages() async {
    final messages = await  _firestore.collection('chat_messages').get();
    for(var message in messages.docs){
      print(message.data());
    }
  }


  void messagesStream() async {
    await for(var snapshot in _firestore.collection('chat_messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(currentUser: loggedInUser.email,),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      try{
                        _firestore.collection('chat_messages').add({'text': messageText, 'sender': loggedInUser.email});
                        textController.clear();
                      }catch(e){
                        print(e);
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MessageStream extends StatelessWidget {
  const MessageStream({super.key, required this.currentUser});
  final String? currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(stream: _firestore.collection('chat_messages').snapshots(),
        builder: (context, snapshot) {
          List<MessageBubble> messageWidgets = [];
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(
              backgroundColor: Colors.deepOrange,
            ),);
          }
          final messages = snapshot.data?.docs.reversed;
          for( var message in messages!){
            final textMessage = message.get('text');
            final messageSender = message.get('sender');

            messageWidgets.insert(0, MessageBubble(sender: messageSender, text: textMessage, isUser: currentUser == messageSender,));
          }
          return Expanded(child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,));
        });
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({super.key, required this.sender, required this.text, required this.isUser});

  final String sender;
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column( crossAxisAlignment: isUser?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
        Text(sender, style: const TextStyle(fontSize: 14, color: Colors.black54),),
          Material(
            borderRadius: isUser?BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)):
            BorderRadius.only(topRight: Radius.circular(20.0), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            elevation: 5.0,
            color: isUser?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(text,
                style: TextStyle(color: Colors.deepOrange[900],
                    fontSize: 20, fontWeight: FontWeight.w400)),
            )),
        ],
      ),
    );
  }
}

