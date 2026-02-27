import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/emergency/screens/home_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/emergency/screens/fake_call_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/contacts/screens/contacts_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authProvider);
  final onboardingAsync = ref.watch(onboardingCompleteProvider);

  final authState = authAsync.value;
  final onboardingDone = onboardingAsync.value ?? false;

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isOnboarding = loc == '/onboarding';
      final isAuth = loc == '/login' || loc == '/register';

      // 1. Show onboarding first if not completed
      if (!onboardingDone && !isOnboarding) {
        return '/onboarding';
      }

      // 2. After onboarding, handle auth
      if (onboardingDone) {
        if (authState == null) return null; // Still loading

        final isLoggedIn = authState.status == AuthStateStatus.authenticated;

        if (!isLoggedIn && !isAuth && !isOnboarding) {
          return '/login';
        }
        if (isLoggedIn && (isAuth || isOnboarding)) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/contacts', builder: (context, state) => const ContactsScreen()),
      GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
      GoRoute(
        path: '/fake-call',
        builder: (context, state) => FakeCallScreen(
          callerName: state.uri.queryParameters['name'] ?? 'Dad',
          callerNumber: state.uri.queryParameters['number'] ?? '+91 98765 43210',
        ),
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
  );
});
