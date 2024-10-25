import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:together/app.dart';
import 'package:together/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
