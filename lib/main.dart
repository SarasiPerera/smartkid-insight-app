
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'firebase_options.dart';
import 'models/models.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Object? startupError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    startupError = e;
  }

  runApp(SmartKidApp(startupError: startupError));
}

class SmartKidApp extends StatelessWidget {
  final Object? startupError;

  const SmartKidApp({super.key, this.startupError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartKid Insight',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: startupError != null
          ? _SetupNeeded(error: startupError!)
          : const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  final AuthService _auth = AuthService();

  late final Stream<UserProfile?> _stream = _auth.profileChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snap.hasError) {
          return _AuthProblem(
            error: snap.error!,
            onSignOut: _auth.signOut,
          );
        }

        final user = snap.data;

        if (user == null) {
          return AuthScreen(auth: _auth);
        }

        return AppShell(
          key: ValueKey(user.id),
          user: user,
          auth: _auth,
        );
      },
    );
  }
}

class _AuthProblem extends StatelessWidget {
  final Object error;
  final Future<void> Function() onSignOut;

  const _AuthProblem({
    required this.error,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final message = error is StateError
        ? error.toString().replaceFirst('Bad state: ', '')
        : 'Unable to load your account profile. '
            'Please check your connection or contact the research team.';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Account profile problem',
                style: sinhalaText(20, weight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: sinhalaText(13, color: AppColors.inkSoft),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await onSignOut();
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupNeeded extends StatelessWidget {
  final Object error;

  const _SetupNeeded({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.settings,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Firebase setup needed',
                style: sinhalaText(20, weight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Run `flutterfire configure` in the project folder, '
                'then restart the app.\n\n$error',
                textAlign: TextAlign.center,
                style: sinhalaText(13, color: AppColors.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
