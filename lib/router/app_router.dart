import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/add_task.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-task',
      builder: (context, state) => const AddTaskPage(),
    ),
  ],
);