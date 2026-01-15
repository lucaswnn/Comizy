import 'package:comizy/tads/help_request.dart';
import 'package:comizy/test/mocks.dart';
import 'package:flutter/material.dart';

class HelpRequestNotifier with ChangeNotifier {
  final Set<HelpRequest> _helpRequests;
  HelpRequest? _actualRequest;

  HelpRequestNotifier() : _helpRequests = mockHelpRequests;

  Set<HelpRequest> get helpRequests => _helpRequests;

  HelpRequest? get request => _actualRequest;

  set currentRequest(HelpRequest? request) {
    _actualRequest = request;
    notifyListeners();
  }
}
