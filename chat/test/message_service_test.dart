// @dart=2.9

import 'package:chat/src/models/message_model.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  MessageService sut;

  setUp(() async {
    connection = await r.connect(host: '127.0.0.1', port: 28015);
    await createDb(r, connection);
    sut = MessageService(connection, r);
  });

  tearDown(() async {
    sut.dispose();
    // await cleanDb(r, connection);
  });

  final user1 = User.fromJson({
    'id': '111',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '123',
    'active': false,
    'lastSeen': DateTime.now(),
  });

  test('sent message successfully', () async {
    Message message = Message(
        from: user1.id,
        to: '1234',
        timestamp: DateTime.now(),
        content: 'This is the first message');

    final res = sut.send(message);
    // expect(res, true);
  });

  test('successfully subscribe and receive messages', () async {
    // sut.messages(activeUser: user2).listen(expectAsync1((message) {
    //       expect(message.to, user2.id);
    //       expect(message.id, isNotEmpty);
    //     }, count: 2));

    Message message1 = Message(
        from: user1.id,
        to: user2.id,
        timestamp: DateTime.now(),
        content: 'This is the first message');

    Message message2 = Message(
        from: user1.id,
        to: user2.id,
        timestamp: DateTime.now(),
        content: 'This is the second message');

    await sut.send(message1);
    await sut.send(message2);
  });


}
