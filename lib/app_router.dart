import 'package:go_router/go_router.dart';
import 'package:midterm_project/screens/homework_add.dart';
import 'package:midterm_project/screens/homework_list.dart';

import 'domain/homework.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeworkListScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddHomeworkScreen(),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final homework = state.extra as Homework?;
          return AddHomeworkScreen(homeworkToEdit: homework);
        },
      ),
    ],
  );
}