// @dart=2.9
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
// import 'package:rethink_db_ns/rethink_db_ns.dart';

Future<void> createDb (Rethinkdb r, Connection connection) async{
  await r.dbCreate('test').run(connection).catchError((err)=>{});
  await r.tableCreate('users').run(connection).catchError((err)=>{});
  await r.tableCreate('messages').run(connection).catchError((err)=>{});
}

Future<void> cleanDb (Rethinkdb r, Connection connection) async{
  await r.table('users').delete().run(connection);
  await r.table('messages').delete().run(connection);
}