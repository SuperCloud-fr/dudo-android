import 'dart:async';
import 'dart:convert';

import 'package:dudo/salon/network_salon_session.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A scripted WebSocket channel: tests push server frames in with
/// [serverSends] and read what the session sent in [sent].
class FakeWebSocketChannel extends StreamChannelMixin
    implements WebSocketChannel {
  FakeWebSocketChannel.confirmed(this.uri) : ready = Future<void>.value();

  /// Emulates an unreachable host: the handshake never completes.
  FakeWebSocketChannel.unreachable(this.uri) : ready = Completer<void>().future;

  final Uri uri;

  @override
  final Future<void> ready;
  final List<String> sent = <String>[];
  final StreamController<String> _incoming = StreamController<String>();
  bool closed = false;

  @override
  Stream<dynamic> get stream => _incoming.stream;

  /// True once the session stopped listening on this channel — what the
  /// double-delivery fix guarantees for any thrown-away socket.
  bool get unlistened => !_incoming.hasListener;

  @override
  WebSocketSink get sink => _FakeSink(this);

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  void serverSends(Map<String, dynamic> frame) {
    _incoming.add(jsonEncode(frame));
  }

  Future<void> serverCloses() async {
    await _incoming.close();
  }
}

class _FakeSink implements WebSocketSink {
  _FakeSink(this.channel) {
    _done.complete();
  }

  final FakeWebSocketChannel channel;
  final Completer<void> _done = Completer<void>();

  @override
  void add(Object? event) => channel.sent.add('$event');

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) async {}

  @override
  Future close([int? closeCode, String? closeReason]) {
    channel.closed = true;
    if (!_done.isCompleted) {
      _done.complete();
    }
    return _done.future;
  }

  @override
  Future<void> get done => _done.future;
}

/// Session driving scripted channels for both candidate hosts.
class Harness {
  final Map<String, FakeWebSocketChannel> channels =
      <String, FakeWebSocketChannel>{};
  late NetworkSalonSession session;

  Harness({int timeoutMillis = 150, String providedCode = 's99fth'}) {
    session = NetworkSalonSession(
      handshakeTimeout: Duration(milliseconds: timeoutMillis),
      createSalonCode: (_, _) async => providedCode,
      channelFactory: (uri) => channels.putIfAbsent(
        uri.toString(),
        () => FakeWebSocketChannel.confirmed(uri),
      ),
    );
  }

  FakeWebSocketChannel channel(String url) {
    final key = Uri.parse(url).toString();
    return channels[key]!;
  }
}

/// Lets microtask chains (socket plumbing) settle.
Future<void> settle([int rounds = 4]) async {
  for (var index = 0; index < rounds; index++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Waits until the session pushed at least one frame through the channel.
Future<void> untilOneSent(FakeWebSocketChannel channel) async {
  for (var index = 0; index < 200; index++) {
    if (channel.sent.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

List<String> framesOf(List<String> sent, String type) =>
    sent.where((frame) => frame.contains('"type":"$type"')).toList();

Map<String, dynamic> salonFrame({
  required List<Map<String, dynamic>> players,
  required int you,
  bool started = false,
  int hostSeat = 0,
}) {
  return <String, dynamic>{
    'type': 'salon',
    'salon': <String, dynamic>{
      'code': 'S99FTH',
      'started': started,
      'hostSeat': hostSeat,
      'players': players,
      'you': you,
    },
  };
}
