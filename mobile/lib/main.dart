import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EventHub',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      routerConfig: router,
    );
  }
}
