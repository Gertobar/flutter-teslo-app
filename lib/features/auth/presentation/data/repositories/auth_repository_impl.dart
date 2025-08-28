import 'package:teslo_app/features/auth/presentation/data/data.dart';
import 'package:teslo_app/features/auth/presentation/domain/domain.dart';

class AuthRepositoryImpl extends AuthRepository{

  final AuthDatasource dataSource;

  AuthRepositoryImpl({
    AuthDatasource? dataSource
}): dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return register(email, password, fullName);
  }
  
}