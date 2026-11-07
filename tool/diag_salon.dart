// Diagnostic salon : reproduit le flux de l'app contre le vrai Worker.
// dart run tool/diag_salon.dart [baseUrl]
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

final base = const bool.hasEnvironment('base')
    ? const String.fromEnvironment('base')
    : 'https://dudo.supercloud.fr';

Future<void> main() async {
  stdout.writeln('== POST $base/api/v1/salons');
  final client = HttpClient();
  final req = await client.postUrl(Uri.parse('$base/api/v1/salons'));
  req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
  req.write(jsonEncode({'name': 'Diag'}));
  final res = await req.close();
  final body = await res.transform(utf8.decoder).join();
  stdout.writeln('POST status=${res.statusCode} body=$body');
  final code = (jsonDecode(body) as Map<String, dynamic>?)?['code'];
  if (code is! String) {
    stdout.writeln('PAS DE CODE — arrêt.');
    exit(2);
  }

  stdout.writeln('== WS $base/api/v1/salons/$code/ws');
  final uri = Uri.parse('$base/api/v1/salons/$code/ws').replace(scheme: 'wss');
  stdout.writeln('ws uri=$uri');
  final ws = WebSocketChannel.connect(uri);
  stdout.writeln('attente ready…');
  await ws.ready;
  stdout.writeln('ready ✓');
  ws.stream.listen(
    (frame) => stdout.writeln('<< ${frame.runtimeType}: $frame'),
    onDone: () {
      stdout.writeln(
        'ws done closeCode=${ws.closeCode} closeReason=${ws.closeReason}',
      );
    },
    onError: (Object error) => stdout.writeln('ws ERROR $error'),
  );

  stdout.writeln('>> join');
  ws.sink.add(jsonEncode({'type': 'join', 'name': 'Diag'}));
  for (var second = 1; second <= 4; second++) {
    await Future<void>.delayed(const Duration(seconds: 1));
    stdout.writeln('... t=$second s');
  }
  stdout.writeln('fin de capture.');
  await ws.sink.close();
  client.close();
}
