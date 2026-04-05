import 'package:comizy/tads/app_user.dart';
import 'package:comizy/test/mocks.dart';
import 'package:flutter/material.dart';

class OtherUsersNotifier with ChangeNotifier {
  final List<AppOtherUser> _otherUsers;

  OtherUsersNotifier() : _otherUsers = mockUsers;

  List<AppOtherUser> get otherUsers => _otherUsers;
}
