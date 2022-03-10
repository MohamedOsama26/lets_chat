// @dart=2.9
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
// import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';


void main() {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  UserService sut;


  setUp(() async {
    connection = await r.connect(host: '127.0.0.1', port: 28015);
    await createDb(r, connection);
    sut = UserService(r, connection);
  });

  tearDown(() async{
    // await cleanDb(r, connection);
  });


  test('creates a new user document in database', () async {
    final user = User(
        username: 'Function5',
        photoUrl: 'url5',
        active: false,
        lastSeen: DateTime.now(),
    );
    final userWithId = await sut.connect(user);
    // expect(userWithId.id, isNotEmpty);
  });

  test('creates a new user document in database', () async {
    final user = User(
      username: 'Function6',
      photoUrl: 'url6',
      active: true,
      lastSeen: DateTime.now(),
    );
    await sut.connect(user);
    // final users = await sut.online();
    // expect(users.length,1);
  });
}