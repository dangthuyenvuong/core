import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:web_socket_channel/io.dart';

class RoomSocket {
  final String id;
  final SocketController controller;
  final Map<String, List<Function(dynamic message)>> _actions = {};

  RoomSocket(this.id, this.controller) {
    // controller.send({
    //   'event': "send_room", // Event trong socket của server
    //   'room': id,
    //   'data': data,
    //   "room_event": "join_room",
    // });
  }

  void send({
    required String event,
    dynamic data,
  }) {
    controller.send({
      'event': "send_room", // Event trong socket của server
      'room': id,
      'data': data,
      "room_event": event,
    });
  }

  void action(
      {required String event, required Function(dynamic message) onMessage}) {
    if (_actions[event] == null) {
      _actions[event] = [];
    }
    _actions[event]?.add(onMessage);
  }

  void message(dynamic message) {
    final event = message['room_event'];
    if (_actions[event] != null) {
      _actions[event]?.forEach((action) => action(message));
    }
  }

  // void listen(dynamic message) {
  //   final data = jsonDecode(message);
  // }

  void dispose() {
    // controller.unlisten(listen);
    controller.leave(id);
  }
}

class SocketController extends GetxController {
  IOWebSocketChannel? channel;
  StreamSubscription<dynamic>? sub;
  String url;

  final Map<String?, List<Function(dynamic message)>> _actions = {};

  final Map<Function(dynamic message), String?> _actionMap = {};

  final Map<String, RoomSocket> _rooms = {};

  SocketController(this.url);

  void init() {
    channel?.sink.close();
    sub?.cancel();

    channel = IOWebSocketChannel.connect(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${Http.getToken?.call()}',
    });

    sub = channel?.stream.listen(_handleMessage, onDone: () {
      print("socket done");
    });
  }

  @override
  void onClose() {
    channel?.sink.close();
    super.dispose();
  }

  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);

    final event = data['event'];
    if (_actions.containsKey(event)) {
      _actions[event]?.forEach((action) => action(data));
    }

    _actions[null]?.forEach((action) => action(message));

    if (event == "send_room") {
      final room = data['room'];
      final roomSocket = _rooms[room];
      if (roomSocket != null) {
        roomSocket.message(data);
      }
    }
  }

  void send(dynamic message) {
    channel?.sink.add(jsonEncode(message));
  }

  Function listen(Function(dynamic message) onMessage, {String? action}) {
    if (_actions[action] == null) {
      _actions[action] = [];
    }
    _actions[action]?.add(onMessage);
    _actionMap[onMessage] = action;

    return () {
      unlisten(onMessage);
    };
  }

  void unlisten(Function(dynamic message) onMessage) {
    final action = _actionMap[onMessage];
    _actions[action]?.remove(onMessage);
    _actionMap.remove(onMessage);
  }

  RoomSocket join(String room) {
    send({
      'event': 'join_room',
      'room': room,
    });

    final roomSocket = RoomSocket(room, this);
    _rooms[room] = roomSocket;

    return roomSocket;
  }

  void leave(String room) {
    send({
      'event': 'leave_room',
      'room': room,
    });
  }
}
