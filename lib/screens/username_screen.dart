import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chating/provider/main_provider.dart';
import 'package:realtime_chating/screens/main_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({
    super.key,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  TextEditingController username = TextEditingController();
  @override
  void dispose() {
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: username,
            decoration: InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) => MainProvider(),
                    child: MainScreenChat(
                      username: username.text.trim(),
                    ),
                  ),
                ),
              );
            },
            child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey,
                child: Text('Login')),
          ),
        ]),
      ),
    );
  }
}
