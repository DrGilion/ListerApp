import 'dart:async';

import 'package:flutter/material.dart';

class DelayedCallback {
  final int milliseconds;
  Timer? _timer;

  DelayedCallback({this.milliseconds = 1000});

  void run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
