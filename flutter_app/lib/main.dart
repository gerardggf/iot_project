import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home/home_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: const IoTProjectApp(),
    ),
  );
}

class IoTProjectApp extends StatelessWidget {
  const IoTProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Project',
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}
