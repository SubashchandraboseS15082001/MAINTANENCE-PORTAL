import 'package:flutter/material.dart';
import 'package:maintenance_portal/workorder.dart';

import 'loginScreen.dart';
import 'notification.dart';
import 'workorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/notification": (context) => const NotifyScreen(),
        "/workorder": (context) => const WorkOrder()
      },
    );
  }
}
