import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chating/models/chat_message.dart';
import 'package:realtime_chating/provider/main_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainScreenChat extends StatefulWidget {
  final String username;
  const MainScreenChat({super.key, required this.username});

  @override
  State<MainScreenChat> createState() => _MainScreenChatState();
}

class _MainScreenChatState extends State<MainScreenChat> {
  late IO.Socket _socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': widget.username}).build());

  _sendMessage() {
    _socket.emit('message',
        {'message': chatBox.text.trim(), 'username': widget.username});
  }

  TextEditingController chatBox = TextEditingController();

  _connectSocket() {
    _socket.onConnect((data) => print('Connection'));
    _socket.onConnectError((data) => print('Connection Error'));
    _socket.onDisconnect((data) => print('Disconnect'));
    _socket.on(
        'message',
        (data) =>
            Provider.of<MainProvider>(context, listen: false).addNewMessage(
              ChatMessage.fromJson(data),
            ));
  }

  @override
  void initState() {
    _connectSocket();
    super.initState();
    _socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).setQuery(
            {'username': widget.username}).build());
  }

  @override
  void dispose() {
    chatBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(166, 124, 188, 1),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Consumer<MainProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.messages.length,
                reverse: true,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment:
                          (value.messages[index].username != widget.username
                              ? Alignment.topLeft
                              : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              value.messages[index].username == widget.username
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(70),
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50))
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(70),
                                      bottomLeft: Radius.circular(50)),
                          color:
                              (value.messages[index].username != widget.username
                                  ? Colors.grey.shade200
                                  : Colors.black),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(117, 63, 146, 1)
                                    .withOpacity(0.5),
                                spreadRadius: -3,
                                offset:
                                    Offset(0, 10) // changes position of shadow
                                ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          value.messages[index].message,
                          style: TextStyle(
                            fontSize: 15,
                            color: (value.messages[index].username ==
                                    widget.username
                                ? Colors.grey.shade200
                                : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: chatBox,
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                if (chatBox.text.trim().isNotEmpty) {
                  _sendMessage();
                  chatBox.clear();
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
