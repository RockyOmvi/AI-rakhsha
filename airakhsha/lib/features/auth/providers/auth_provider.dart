import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_storage_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) => LocalStorageService());

enum AuthStateStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStateStatus status;
  final String? name;
  final String? email;
  final String? errorMessage;

  AuthState({this.status = AuthStateStatus.initial, this.name, this.email, this.errorMessage});

  AuthState copyWith({AuthStateStatus? status, String? name, String? email, String? errorMessage, bool clearError = false}) {
    return AuthState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final storage = ref.read(localStorageProvider);
    final session = await storage.getSession();
    if (session != null) {
      return AuthState(
        status: AuthStateStatus.authenticated,
        name: session['name'],
        email: session['email'],
      );
    }
    return AuthState(status: AuthStateStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    state = AsyncData(state.value!.copyWith(status: AuthStateStatus.loading, clearError: true));
    try {
      final storage = ref.read(localStorageProvider);
      final user = await storage.loginUser(email, password);
      if (user != null) {
        state = AsyncData(AuthState(
          status: AuthStateStatus.authenticated,
          name: user['name'],
          email: user['email'],
        ));
      } else {
        state = AsyncData(state.value!.copyWith(
          status: AuthStateStatus.error,
          errorMessage: 'Invalid email or password',
        ));
      }
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        status: AuthStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> register(String name, String email, String password, String phone) async {
    state = AsyncData(state.value!.copyWith(status: AuthStateStatus.loading, clearError: true));
    try {
      final storage = ref.read(localStorageProvider);
      final success = await storage.registerUser(name, email, password, phone);
      if (success) {
        state = AsyncData(AuthState(
          status: AuthStateStatus.authenticated,
          name: name,
          email: email,
        ));
      } else {
        state = AsyncData(state.value!.copyWith(
          status: AuthStateStatus.error,
          errorMessage: 'Email already registered',
        ));
      }
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        status: AuthStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    final storage = ref.read(localStorageProvider);
    await storage.logout();
    state = AsyncData(AuthState(status: AuthStateStatus.unauthenticated));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
