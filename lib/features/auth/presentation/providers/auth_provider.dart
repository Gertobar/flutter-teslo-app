import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/data/data.dart';
import 'package:teslo_app/features/auth/presentation/domain/domain.dart';
import 'package:teslo_app/features/shared/data/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final keyValueStorageService = KeyValueStorageServiceImpl();

  AuthNotifier({
    required this.authRepository,
    required KeyValueStorageServiceImpl keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

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

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if(token == null) return logOut();
    try {

      final user = await authRepository.checkAuthStatus(token);
      _setLoggerUser(user);
      
    } catch (e) {
      logOut();
    }
  }

  void _setLoggerUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logOut([String? errorMessge]) async {
    await keyValueStorageService.removeKey('token');
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
