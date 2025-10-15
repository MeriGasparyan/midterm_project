import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'app_router.dart';
import 'bloc/homework_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeworkBloc(),
      child: MaterialApp.router(
        title: 'Homework Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: AppRouter.router,
      ),
    );
  }
}