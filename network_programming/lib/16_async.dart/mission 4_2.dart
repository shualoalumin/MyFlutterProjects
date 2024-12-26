import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StreamController<List<String>> _messageController =
      StreamController<List<String>>();
  final StreamController<bool> _typingController =
      StreamController<bool>();
  final List<String> _messages = [];
  final TextEditingController _textController =
      TextEditingController();

  @override
  void dispose() {
    _messageController.close();
    _typingController.close();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _messages.add(message);
      _messageController.sink.add(_messages);
      _typingController.sink.add(false);
      _textController.clear();
    }
  }

  void _onTyping(String input) {
    _typingController.sink.add(input.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('미션 4-2 실시간 채팅앱'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _messageController.stream,
              initialData: _messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('메세지가 없습니다.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _typingController.stream,
            initialData: false,
            builder: (context, snapshot) {
              return snapshot.data!
                  ? Text('상대방이 입력중입니다...', style: TextStyle(color: Colors.grey))
                  : SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: _onTyping,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: '메세지를 입력하세요.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
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
