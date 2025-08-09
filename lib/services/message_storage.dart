class MessageStorage {
  static final MessageStorage _instance = MessageStorage._internal();
  factory MessageStorage() => _instance;
  MessageStorage._internal();

  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => List.unmodifiable(_messages);

  void addMessage(String sender, String content, DateTime timestamp) {
    _messages.add({
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
    });
  }

  void clearMessages() {
    _messages.clear();
  }

  List<Map<String, dynamic>> getMessagesBySender(String sender) {
    return _messages.where((message) => message['sender'] == sender).toList();
  }
}
