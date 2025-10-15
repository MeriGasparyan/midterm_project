import 'package:bloc/bloc.dart';
import '../domain/homework.dart';

abstract class HomeworkEvent {}

class LoadHomeworksEvent extends HomeworkEvent {}

class AddHomeworkEvent extends HomeworkEvent {
  final Homework homework;

  AddHomeworkEvent(this.homework);
}

class EditHomeworkEvent extends HomeworkEvent {
  final Homework homework;

  EditHomeworkEvent(this.homework);
}

class ToggleHomeworkEvent extends HomeworkEvent {
  final String homeworkId;

  ToggleHomeworkEvent(this.homeworkId);
}

abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final List<Homework> homeworks;

  HomeworkLoaded(this.homeworks);
}

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final List<Homework> _homeworks = [];

  HomeworkBloc() : super(HomeworkInitial()) {
    on<LoadHomeworksEvent>((event, emit) {
      emit(HomeworkLoaded(List.from(_homeworks)));
    });

    on<AddHomeworkEvent>((event, emit) {
      _homeworks.add(event.homework);
      emit(HomeworkLoaded(List.from(_homeworks)));
    });

    on<EditHomeworkEvent>((event, emit) {
      final index = _homeworks.indexWhere((hw) => hw.id == event.homework.id);
      if (index != -1) {
        _homeworks[index] = event.homework;
        emit(HomeworkLoaded(List.from(_homeworks)));
      }
    });

    on<ToggleHomeworkEvent>((event, emit) {
      final index = _homeworks.indexWhere((hw) => hw.id == event.homeworkId);
      if (index != -1) {
        _homeworks[index] = Homework(
          id: _homeworks[index].id,
          subject: _homeworks[index].subject,
          title: _homeworks[index].title,
          description: _homeworks[index].description,
          dueDate: _homeworks[index].dueDate,
          isCompleted: !_homeworks[index].isCompleted,
        );
        emit(HomeworkLoaded(List.from(_homeworks)));
      }
    });
  }
}
