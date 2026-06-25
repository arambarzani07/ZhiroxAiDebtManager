import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/platform_core/platform_dashboard_screen.dart';
import 'features/platform_core/platform_service.dart';

class ZhiroxApp extends StatefulWidget {
  const ZhiroxApp({super.key});

  @override
  State<ZhiroxApp> createState() => _ZhiroxAppState();
}

class _ZhiroxAppState extends State<ZhiroxApp> {
  late final ApiClient apiClient;
  late final AuthService authService;
  bool loading = true;
  bool loggedIn = false;
  String sessionKind = 'tenant';

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    authService = AuthService(apiClient);
    _restore();
  }

  Future<void> _restore() async {
    final token = await authService.restoreToken();
    final kind = await authService.restoreSessionKind();
    setState(() {
      loggedIn = token != null && token.isNotEmpty;
      sessionKind = kind;
      loading = false;
    });
  }

  void _onLogin(String kind) => setState(() {
        loggedIn = true;
        sessionKind = kind;
      });

  Future<void> _onLogout() async {
    await authService.logout();
    setState(() {
      loggedIn = false;
      sessionKind = 'tenant';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zhirox AI Debt',
      theme: AppTheme.dark(),
      locale: const Locale('ckb'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: loading
          ? const _BootScreen()
          : loggedIn
              ? sessionKind == 'owner'
                  ? PlatformDashboardScreen(platformService: PlatformService(apiClient), onLogout: _onLogout)
                  : DashboardScreen(authService: authService, onLogout: _onLogout)
              : LoginScreen(authService: authService, onLogin: _onLogin),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
