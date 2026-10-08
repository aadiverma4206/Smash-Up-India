import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/login_request_model.dart';
import 'package:all_stars_arena/data/models/user_model.dart';

void main() {
  group('ALL STARS ARENA Authentication Module Unit Tests', () {
    test('LoginRequestModel converts correctly for Email and Mobile login', () {
      final emailLogin = LoginRequestModel(
        identifier: 'player@example.com',
        password: 'Password123!',
      );
      expect(emailLogin.toJson()['identifier'], 'player@example.com');

      final mobileLogin = LoginRequestModel(
        identifier: '+919876543210',
        password: 'Password123!',
      );
      expect(mobileLogin.toJson()['identifier'], '+919876543210');
    });

    test('UserModel deserializes authoritative backend role correctly', () {
      final jsonPlayer = {
        'id': 'usr_p101',
        'name': 'Test Player',
        'email': 'player@example.com',
        'phone': '+919876543210',
        'roleId': 3,
        'roleName': 'PLAYER',
        'status': 'ACTIVE',
        'city': 'Raipur',
      };

      final user = UserModel.fromJson(jsonPlayer);
      expect(user.roleId, 3);
      expect(user.roleName, 'PLAYER');
      expect(user.status, 'ACTIVE');
    });

    test('Suspended user status is detected correctly', () {
      final jsonSuspended = {
        'id': 'usr_suspended_101',
        'name': 'Suspended User',
        'email': 'bad@example.com',
        'phone': '+919000000000',
        'roleId': 3,
        'roleName': 'PLAYER',
        'status': 'SUSPENDED',
      };

      final user = UserModel.fromJson(jsonSuspended);
      expect(user.status, 'SUSPENDED');
    });
  });
}
