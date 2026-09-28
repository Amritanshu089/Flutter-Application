import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'screens/home_page.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routerConfig: appRouter,
    );
  }
}

