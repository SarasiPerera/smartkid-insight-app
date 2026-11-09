import 'dart:math';

import 'package:flutter/material.dart';

import 'models/models.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/local_store.dart';
import 'services/tts_service.dart';
import 'theme.dart';
import 'screens/activity_menu_screen.dart';
import 'screens/activity_play_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_create_screen.dart';
import 'screens/rest_break_screen.dart';
import 'screens/results_screen.dart';
import 'screens/welcome_screen.dart';

enum AppScreen {
  home,
  welcome,
  profileCreate,
  activityMenu,
  activityPlay,
  restBreak,
  results,
  dashboard,
}

/// Screen flow ported from the web prototype's App.tsx:
/// welcome -> profile -> activity menu -> play -> (rest break after 2) -> results.
class AppShell extends StatefulWidget {
  final UserProfile user;
  final AuthService auth;
  const AppShell({super.key, required this.user, required this.auth});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final FirestoreService _fs = FirestoreService();
  final TtsService _tts = TtsService();

  bool _loading = true;
  AppScreen _screen = AppScreen.welcome;
  List<ChildProfile> _children = [];
  ChildProfile? _child;
  AssessmentSession? _session;
  final List<AssessmentResponse> _responses = [];
  ActivityType _activity = ActivityType.sinhalaLetters;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _init() async {
    final kids = await LocalStore.children(widget.user.id);
    final currentId = await LocalStore.currentChildId();
    ChildProfile? current;
    for (final c in kids) {
      if (c.childId == currentId) current = c;
    }
    current ??= kids.isNotEmpty ? kids.first : null;
    if (!mounted) return;
    setState(() {
      _children = kids;
      _child = current;
      _screen = kids.isEmpty ? AppScreen.welcome : AppScreen.home;
      _loading = false;
    });
  }

  String _sessionId() =>
      'ses_${Random.secure().nextInt(1 << 31).toRadixString(36)}';

  
void _startSession([ChildProfile? child]) {
  final target = child ?? _child;

  if (target == null) {
    setState(() => _screen = AppScreen.profileCreate);
    return;
  }

  final newSession = AssessmentSession(
    sessionId: _sessionId(),
    childId: target.childId,
    ownerId: widget.user.id,
    ageBand: target.ageBand,
    completedActivities: const [],
    startTime: DateTime.now(),
  );

  setState(() {
    _child = target;
    _session = newSession;
    _responses.clear();
    _screen = AppScreen.activityMenu;
  });

  // Create the session document before saving assessment responses.
  _fs.saveSession(newSession);
}


  void _onActivityComplete() {
    final s = _session;
    if (s == null) return;
    final done = {...s.completedActivities, _activity}.toList();
    setState(() {
      _session = s.copyWith(completedActivities: done);
      // A rest break after the second finished activity (same as the web app).
      _screen = done.length == 2 ? AppScreen.restBreak : AppScreen.activityMenu;
    });
  }

  void _finishSession() {
    final s = _session;
    if (s != null) {
      final finished = s.copyWith(endTime: DateTime.now(), isComplete: true);
      _fs.saveSession(finished);
      _session = finished;
    }
    setState(() => _screen = AppScreen.results);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final showNav = _screen == AppScreen.home || _screen == AppScreen.dashboard;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartKid Insight',
          style: sinhalaText(17, weight: FontWeight.w900),
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                widget.user.role.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStore.clearCurrentChild();
              await widget.auth.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(child: _body()),
      bottomNavigationBar: showNav
          ? NavigationBar(
              selectedIndex: _screen == AppScreen.dashboard ? 1 : 0,
              onDestinationSelected: (i) => setState(
                () => _screen = i == 0 ? AppScreen.home : AppScreen.dashboard,
              ),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Dashboard',
                ),
              ],
            )
          : null,
    );
  }

  Widget _body() {
    switch (_screen) {
      case AppScreen.welcome:
        return WelcomeScreen(
          tts: _tts,
          onContinue: () => setState(
            () => _screen = _children.isEmpty
                ? AppScreen.profileCreate
                : AppScreen.home,
          ),
        );
      case AppScreen.home:
        return HomeScreen(
          user: widget.user,
          children: _children,
          currentChild: _child,
          onSelectChild: (c) {
            LocalStore.setCurrentChild(c.childId);
            setState(() => _child = c);
          },
          onCreateChild: () =>
              setState(() => _screen = AppScreen.profileCreate),
          onStartSession: () => _startSession(),
        );
      case AppScreen.profileCreate:
        return ProfileCreateScreen(
          ownerId: widget.user.id,
          onCancel: () => setState(
            () => _screen = _children.isEmpty
                ? AppScreen.welcome
                : AppScreen.home,
          ),
          onCreated: (c) async {
            await LocalStore.addChild(c);
            if (!mounted) return;
            setState(() => _children = [..._children, c]);
            _startSession(c);
          },
        );
      case AppScreen.activityMenu:
        return ActivityMenuScreen(
          child: _child!,
          session: _session!,
          onSelect: (t) => setState(() {
            _activity = t;
            _screen = AppScreen.activityPlay;
          }),
          onRestBreak: () => setState(() => _screen = AppScreen.restBreak),
          onFinish: _finishSession,
        );
      case AppScreen.activityPlay:
        return ActivityPlayScreen(
          key: ValueKey(_activity),
          activityType: _activity,
          child: _child!,
          session: _session!,
          tts: _tts,
          onResponse: (r) {
            _responses.add(r);
            _fs.saveResponse(r);
          },
          onComplete: _onActivityComplete,
          onBack: () => setState(() => _screen = AppScreen.activityMenu),
        );
      case AppScreen.restBreak:
        return RestBreakScreen(
          onContinue: () => setState(() => _screen = AppScreen.activityMenu),
          onFinish: _finishSession,
        );
      case AppScreen.results:
        return ResultsScreen(
          child: _child!,
          responses: List.of(_responses),
          onHome: () => setState(() => _screen = AppScreen.home),
          onDashboard: () => setState(() => _screen = AppScreen.dashboard),
        );
      case AppScreen.dashboard:
        return DashboardScreen(user: widget.user, firestore: _fs);
    }
  }
}

