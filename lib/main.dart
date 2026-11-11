import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'auth/auth_provider.dart';
import 'core/api/api_client.dart';
import 'providers/beranda_provider.dart';
import 'providers/stok_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthProvider();
  await auth.muatSesi();

  ApiClient.onUnauthorized = () {
    auth.bersihkanSesi();
    App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (_) => false,
    );
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider(create: (_) => BerandaProvider()),
        ChangeNotifierProvider(create: (_) => StokProvider()),
      ],
      child: App(initialRoute: auth.sudahLogin ? '/beranda' : '/login'),
    ),
  );
}
