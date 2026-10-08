import '../datasources/auth_remote_datasource.dart';
import '../../../data/models/login_request_model.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/models/register_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/session_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    return await remoteDataSource.login(request);
  }

  Future<UserModel> getMe() async {
    return await remoteDataSource.getMe();
  }

  Future<void> sendRegisterOtp(RegisterSendOtpRequestModel request) async {
    return await remoteDataSource.sendRegisterOtp(request);
  }

  Future<String> verifyRegisterOtp(RegisterVerifyOtpRequestModel request) async {
    return await remoteDataSource.verifyRegisterOtp(request);
  }

  Future<LoginResponseModel> registerPlayer(RegisterPlayerRequestModel request) async {
    return await remoteDataSource.registerPlayer(request);
  }

  Future<void> forgotSendOtp(String identifier) async {
    return await remoteDataSource.forgotSendOtp(identifier);
  }

  Future<String> forgotVerifyOtp(String identifier, String otp) async {
    return await remoteDataSource.forgotVerifyOtp(identifier, otp);
  }

  Future<void> resetPassword(String token, String newPassword) async {
    return await remoteDataSource.resetPassword(token, newPassword);
  }

  Future<List<SessionModel>> getSessions() async {
    return await remoteDataSource.getSessions();
  }

  Future<void> revokeSession(String id) async {
    return await remoteDataSource.revokeSession(id);
  }

  Future<void> logout() async {
    // Local logout
  }
}
