import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await Hive.initFlutter();

  // Read onboarding state synchronously BEFORE the app starts
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_complete') ?? false;

  runApp(
    ProviderScope(
      child: OnboardingInitializer(
        onboardingDone: onboardingDone,
        child: const AIRakshaApp(),
      ),
    ),
  );
}

class OnboardingInitializer extends ConsumerWidget {
  final bool onboardingDone;
  final Widget child;
  const OnboardingInitializer({super.key, required this.onboardingDone, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Seed the notifier with the value read from SharedPreferences at startup
    if (onboardingDone) {
      Future.microtask(() => ref.read(onboardingCompleteProvider.notifier).markComplete());
    }
    return child;
  }
}

class AIRakshaApp extends ConsumerWidget {
  const AIRakshaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'AI Raksha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
