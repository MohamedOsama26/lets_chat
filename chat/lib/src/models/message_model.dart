class Message {
  String? get id => _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String content;
  String? _id;

  Message({
    required this.from,
    required this.to,
    required this.timestamp,
    required this.content,
  });

  toJson() =>
      {'from': from, 'to': to, 'timestamp': timestamp, 'content': content};

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'],
        content: json['content']);

    message._id = json['id'];

    return message;
  }
}
