import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthCreateAccountStatus {
  success,
  existingEmail,
  invalidEmail,
  weakPassword,
  tooManyRequests,
  networkRequestFailed,
  unknownError,
}

enum AuthLoginStatus {
  success,
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  tooManyRequests,
  networkRequestFailed,
  invalidCredential,
  unknownError,
}

enum AuthRecoverPasswordStatus {
  success,
  invalidEmail,
  tooManyRequests,
  networkRequestFailed,
  unknownError,
}

enum AuthUpdatePasswordStatus {
  success,
  weakPassword,
  differentFromOldPassword,
  notAuthenticated,
  tooManyRequests,
  networkRequestFailed,
  unknownError,
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthCreateAccountStatus> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        return AuthCreateAccountStatus.success;
      }

      return AuthCreateAccountStatus.unknownError;
    } on AuthException catch (e) {
      return _mapCreateAccountError(e);
    } catch (e) {
      return AuthCreateAccountStatus.unknownError;
    }
  }

  AuthCreateAccountStatus _mapCreateAccountError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('already registered')) {
      return AuthCreateAccountStatus.existingEmail;
    }
    if (message.contains('invalid email')) {
      return AuthCreateAccountStatus.invalidEmail;
    }
    if (message.contains('password')) {
      return AuthCreateAccountStatus.weakPassword;
    }
    if (message.contains('too many requests')) {
      return AuthCreateAccountStatus.tooManyRequests;
    }
    if (message.contains('network')) {
      return AuthCreateAccountStatus.networkRequestFailed;
    }

    return AuthCreateAccountStatus.unknownError;
  }

  Future<AuthLoginStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        return AuthLoginStatus.success;
      }

      return AuthLoginStatus.invalidCredential;
    } on AuthException catch (e) {
      return _mapLoginError(e);
    } catch (_) {
      return AuthLoginStatus.unknownError;
    }
  }

  AuthLoginStatus _mapLoginError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return AuthLoginStatus.invalidCredential;
    }
    if (message.contains('email')) {
      return AuthLoginStatus.invalidEmail;
    }
    if (message.contains('user not found')) {
      return AuthLoginStatus.userNotFound;
    }
    if (message.contains('too many requests')) {
      return AuthLoginStatus.tooManyRequests;
    }
    if (message.contains('network')) {
      return AuthLoginStatus.networkRequestFailed;
    }

    return AuthLoginStatus.unknownError;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<AuthRecoverPasswordStatus> recoverPasswordByEmail({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: kIsWeb ? null : 'io.supabase.comizy://reset-password/',
      );
      return AuthRecoverPasswordStatus.success;
    } on AuthException catch (e) {
      return _mapRecoverPasswordError(e);
    } catch (_) {
      return AuthRecoverPasswordStatus.unknownError;
    }
  }

  AuthRecoverPasswordStatus _mapRecoverPasswordError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid email')) {
      return AuthRecoverPasswordStatus.invalidEmail;
    }
    if (message.contains('too many requests')) {
      return AuthRecoverPasswordStatus.tooManyRequests;
    }
    if (message.contains('network')) {
      return AuthRecoverPasswordStatus.networkRequestFailed;
    }

    return AuthRecoverPasswordStatus.unknownError;
  }

  Future<AuthUpdatePasswordStatus> updatePassword({
    required String password,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: password.trim()),
      );
      return AuthUpdatePasswordStatus.success;
    } on AuthException catch (e) {
      return _mapUpdatePasswordError(e);
    } catch (_) {
      return AuthUpdatePasswordStatus.unknownError;
    }
  }

  AuthUpdatePasswordStatus _mapUpdatePasswordError(AuthException e) {
    final message = e.message.toLowerCase();
    print(message);

    if (message.contains('old password')) {
      return AuthUpdatePasswordStatus.differentFromOldPassword;
    }
    if (message.contains('password')) {
      return AuthUpdatePasswordStatus.weakPassword;
    }
    if (message.contains('too many requests')) {
      return AuthUpdatePasswordStatus.tooManyRequests;
    }
    if (message.contains('network')) {
      return AuthUpdatePasswordStatus.networkRequestFailed;
    }
    if (message.contains('session') ||
        message.contains('authenticated') ||
        message.contains('authorization')) {
      return AuthUpdatePasswordStatus.notAuthenticated;
    }

    return AuthUpdatePasswordStatus.unknownError;
  }
}
