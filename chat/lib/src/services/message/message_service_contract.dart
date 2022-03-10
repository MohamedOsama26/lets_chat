import 'package:chat/src/models/message_model.dart';

import '../../models/user.dart';

abstract class IMessageService {
  Future<bool> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}