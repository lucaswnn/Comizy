import 'package:comizy/tads/user.dart';
import 'package:comizy/test/mocks.dart';
import 'package:flutter/material.dart';

class OtherUsersNotifier with ChangeNotifier {
  final List<OtherUser> _otherUsers;

  OtherUsersNotifier() : _otherUsers = mockUsers;

  List<OtherUser> get otherUsers => _otherUsers;
}