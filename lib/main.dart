import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'app/app.dart';

void main() async {
  await bootstrap(envFile: '.env.dev');
  runApp(const SmashUpIndiaApp());
}
