
import 'package:flutter/material.dart';

import 'auth/login_page.dart';
import 'core/shared/app_theme.dart';
import 'pages/beranda/beranda_page.dart';
import 'pages/stok/update_stok_page.dart';
import 'pages/pesanan/status_order_page.dart';

class App extends StatelessWidget {
  const App({super.key, this.initialRoute = '/login'});

  final String initialRoute;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Royal Florist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFEFE3E3),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        late final Widget page;

        switch (settings.name) {
          case '/login':
            page = const LoginPage();
            break;

          case '/beranda':
            page = const BerandaPage();
            break;

          case '/update-stok':
            page = const UpdateStokPage();
            break;

          case '/status-order':
            page = const StatusOrderPage();
            break;

          default:
            page = _PlaceholderPage(
              title: settings.name ?? 'Halaman tidak ditemukan',
            );
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Halaman $title belum dibuat'),
      ),
    );
  }
}
