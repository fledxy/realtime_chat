import 'package:flutter/material.dart';
import 'package:realtime_chating/models/chat_message.dart';

class MainProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  addNewMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }
}
