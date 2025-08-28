import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/data/data.dart';
import 'package:teslo_app/features/auth/presentation/domain/domain.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(microseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLoggerUser(user);
    } on CustomError catch (e) {
      logOut(e.message);
    } catch (e) {
      logOut('error no controlado');
    }
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {}

  void _setLoggerUser(User user) {
    state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  }

  Future<void> logOut(String errorMessge) async {
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessge,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
