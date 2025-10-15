import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/homework_bloc.dart';

class HomeworkListScreen extends StatelessWidget {
  const HomeworkListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state is HomeworkInitial) {
            context.read<HomeworkBloc>().add(LoadHomeworksEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeworkLoaded) {
            final homeworks = state.homeworks;

            if (homeworks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment, size: 64, color: Colors.blue[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'No homework yet!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: homeworks.length,
              itemBuilder: (context, index) {
                final homework = homeworks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: homework.isCompleted ? Colors.blue[50] : Colors.white,
                  child: ListTile(
                    leading: Checkbox(
                      value: homework.isCompleted,
                      onChanged: (value) {
                        context.read<HomeworkBloc>().add(
                          ToggleHomeworkEvent(homework.id),
                        );
                      },
                      activeColor: Colors.blue,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homework.subject,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          homework.title,
                          style: TextStyle(
                            decoration: homework.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(homework.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${homework.dueDate.day}/${homework.dueDate.month}/${homework.dueDate.year}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      context.go('/edit/${homework.id}', extra: homework);
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
