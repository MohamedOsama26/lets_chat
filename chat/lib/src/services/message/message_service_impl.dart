import 'dart:async';

import 'package:chat/src/models/message_model.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Connection _connection;
  final Rethinkdb r;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changeFeed;

  MessageService(this._connection, this.r);

  @override
  dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    Map record =
        await r.table('messages').insert(message.toJson()).run(_connection);
    return record['inserted'] == 1;
  }

  _startReceivingMessages(User user) {
    _changeFeed = r
        .table('messages')
        .filter({'to': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final message = _messageFromFeed(feedData);
            _controller.sink.add(message);
            _removeDeliveredMessage(message);
          }).catchError((error, stackTrace) => print(error));
        });
  }

  Message _messageFromFeed(feedData) {
    return Message.fromJson(feedData['new_val']);
  }

  _removeDeliveredMessage(message) {
    r
        .table('message')
        .get(message.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
