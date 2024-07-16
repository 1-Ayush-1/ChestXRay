import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // List to hold chat messages
  ScrollController _scrollController = ScrollController();

  void onHomeButtonPressed() {
    print("Home button clicked");
  }

  void onSettingsButtonPressed() {
    print("Settings button clicked");
  }

  void onMessagesButtonPressed() {
    print("Messages button clicked");
  }

  void onAttachButtonPressed() {
    print("Attach button clicked");
  }

  void onSendButtonPressed() {
    print("Send button clicked");
    _chat(); // Call the function to send message
  }

  Future<void> _chat() async {
    String url = 'http://51.20.3.117/chat/create_message/';
    String bearerToken = '4d256ea6d224c62ed2cf021786193c16222b7c04';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$bearerToken',
        },
        body: jsonEncode({
          'message': _messageController.text,
          'sender' : 'patient',
          'chat' : '3e1a70fd-ce0d-48c7-9672-7d534c61fb85'
        }),
      );

      print('Sending POST request to: $url');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        // Message sent successfully
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['message'];
        print('Message Sent. Token: $token');
        _messageController.clear(); // Clear message input field
        // Optionally, fetch messages after sending a message
        _fetchMessages();
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        // Handle authorization or not found errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Problem in sending the message."),
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
    String url = 'http://51.20.3.117/chat/get_message/'; // Replace with your API endpoint
    String bearerToken = '4d256ea6d224c62ed2cf021786193c16222b7c04';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$bearerToken',
        },
      );

      print('Fetching messages from: $url');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Successful fetch
        List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          messages.clear(); // Clear previous messages
          messages.addAll(responseData.map((message) => message['text'].toString()));
        });

        // Scroll to the end of the list after updating messages
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        // Handle other status codes
        print('Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error during fetching messages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello Saumya", style: TextStyle(color: Colors.white)),
                Text("@20B413",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 10),
                Text("Dr. John", style: TextStyle(fontSize: 16)),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(messages[index]),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
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
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.blue),
                  onPressed: onAttachButtonPressed,
                ),
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
                  onPressed: onSendButtonPressed,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              onHomeButtonPressed();
              break;
            case 1:
              onSettingsButtonPressed();
              break;
            case 2:
              onMessagesButtonPressed();
              break;
          }
        },
      ),
    );
  }
}