import 'package:flutter/material.dart';

class AgendadoNavGlobalKey {
  static AgendadoNavGlobalKey? _instance;

  final navKey = GlobalKey<NavigatorState>();

  AgendadoNavGlobalKey._();

  static AgendadoNavGlobalKey get instance =>
      _instance ??= AgendadoNavGlobalKey._();
}
