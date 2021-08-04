import 'dart:async';
import 'dart:io';

class NeuronServer {
  final WebSocket _socket;

  const NeuronServer(this._socket);

  void send(String data) {
    _socket.add(data);
  }

  void listen(Function(dynamic event) listener) {
    _socket.listen(listener);
  }

  static Stream<NeuronServer> start() {
    final _controller = StreamController<NeuronServer>();
    HttpServer.bind('localhost', 35903).then((server) {
      server.transform(WebSocketTransformer()).listen((e) {
        _controller.add(NeuronServer(e));
      });
    });
    return _controller.stream;
  }
}
