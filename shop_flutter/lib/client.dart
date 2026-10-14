import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shop_client/shop_client.dart';

/// Override at run time, for example:
///   flutter run --dart-define=API_URL=http://localhost:8080/
const _apiUrl = String.fromEnvironment('API_URL');

/// Android emulator reaches the host machine via 10.0.2.2.
String get serverUrl {
  if (_apiUrl.isNotEmpty) return _apiUrl;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8080/';
  }
  return 'http://localhost:8080/';
}

late final Client client;

Future<void> initClient() async {
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();
}
