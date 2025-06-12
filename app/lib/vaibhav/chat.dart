import 'dart:convert';
import 'package:check/saumya/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:check/saumya/user_provider.dart';



// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String? Namee;
  String? token;
  String? chatStaticId;
  String? occupation;
  ChatScreen({super.key, this.token, this.chatStaticId, this.occupation, this.Namee});


   @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isSendingMessage = false;
  
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the screen loads
    print(widget.occupation);
  }
  
  Future<void> _chat() async {
    String url = 'http://51.20.3.117/api/chat/create_message/';
    isSendingMessage = true;
    // String counter = (widget.occupation == null) ? 'patient' : (widget.occupation.toString());
    // print(counter);
    print("ho gya ${widget.occupation.toString()}");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.token}',
        },
        body: jsonEncode({
          'message': _messageController.text ?? '', // Ensure _messageController.text is not null
          'sender': widget.occupation,
          'chat': widget.chatStaticId,
        }),
      );

      print('Sending POST request to: $url');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        // Message sent successfully
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['message'] ?? ''; // Handle null case
        print(message);
        setState(() {
          messages.add({
            'message': message,
            'sender': widget.occupation,
            'timestamp': DateTime.now().toString(),
            'chat': 'chat',
          });
        });
        _messageController.clear();
        _scrollToBottom();
      } else {
        // Handle other status codes
        print('Failed to send. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error during sending message: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to connect to the server. Please check your connection."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _fetchMessages() async {
    String url = 'http://51.20.3.117/api/chat/get_message/';
    try {
      final response = await http.get(
        Uri.parse('$url?chat_static_id=${widget.chatStaticId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.token}',
        },
      );

      print('Fetching messages from: $url');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successful fetch
        dynamic responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          List<dynamic> messagesData = responseData['data'];

          // Sort messages by timestamp assuming 'timestamp' field is present in the response
          messagesData.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

          setState(() {
            messages.clear(); // Clear previous messages
            messages.addAll(messagesData.map((message) => {
              'message': message['message'].toString() ?? '', // Handle null case
              'sender': message['sender'], // Assuming 'sender' field is in the response
              'timestamp': message['timestamp'] ?? '', // Handle null case
              'chat': 'fetch',
            }));
          });
          _scrollToBottom(); // Scroll to bottom after fetching messages
        } else {
          // Handle case where responseData is not a List
          print('Failed to fetch messages. Invalid response data format.');
        }
      } else {
        // Handle other status codes
        print('Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error during fetching messages: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to connect to the server. Please check your connection."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _clearAllMessages() {
    setState(() {
      messages.clear(); // Clear all messages from the local state
    });
    print('All messages cleared successfully.');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userzzz = userProvider.user;
    String occup =(userzzz!.occupation == null ) ? 'patient' :  (userzzz.occupation != null && userzzz.occupation == 'Doc') ? 'doctor' : 'patient';

    String name = userzzz.username;
    if(name.length <4) name=name;
    else name=name.substring(0,4);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( "Hello $name...", style: TextStyle(color: Colors.white)),
               SizedBox(height: 5,),
                if(userzzz.username.length > 10 )Text(userzzz.name.substring(0,10), style: TextStyle(color: Colors.white70, fontSize: 14)),
                
                if(userzzz.username.length <=10)  Text(userzzz.name, style: TextStyle(color: Colors.white70, fontSize: 14))
                  
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Confirm clearing all messages
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Clear All Messages"),
                    content: const Text("Are you sure you want to clear all messages?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _clearAllMessages();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMessages,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 10),
                     if(userzzz.occupation != null&&userzzz.occupation == 'Doc') Text("Patient", style: TextStyle(fontSize: 16)),
                     if(userzzz.occupation !=null&&userzzz.occupation == 'Pat') Text("Doctor", style: TextStyle(fontSize: 16)),
                     if(userzzz.occupation ==null)  Text("Doctor", style: TextStyle(fontSize: 16)),
                    //  if(userzzz.occupation !=null)  Text("Patient", style: TextStyle(fontSize: 16)),
                // Text(widget.Namee!, style: TextStyle(fontSize: 16)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _fetchMessages,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.lightBlue[50],
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageBubble(
                    text: messages[index]['message'],
                    isSentByMe: messages[index]['sender'] == widget.occupation,
                    timestamp: messages[index]['timestamp'],
                    check: messages[index]['chat'],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chat(); // Call _chat only if there's a message to send
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSentByMe;
  final String timestamp;
  final String check;

  MessageBubble({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    required this.check,
  });

  @override
  Widget build(BuildContext context) {
    final bool ans;
    // Determine crossAxisAlignment based on both isSentByMe and check
    CrossAxisAlignment alignment;
    if (check == 'fetch') {
      if(isSentByMe){
        alignment = CrossAxisAlignment.end;
        ans=true;
      } 
      else {
        alignment = CrossAxisAlignment.start;
        ans=false;
      }
    } else {
      alignment = CrossAxisAlignment.end;
      ans = true;
    }

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: ans ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text, // No need to handle null case if text is required
                style: TextStyle(
                  color: ans ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                timestamp, // No need to handle null case if timestamp is required
                style: TextStyle(
                  fontSize: 12,
                  color: ans ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}