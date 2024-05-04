class ChatMessage {
  String message;
  String username;
  ChatMessage({
    required this.message,
    required this.username,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> message) {
    return ChatMessage(
      message: message['message'],
      username: message['username'],
    );
  }
}
