import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/homework_bloc.dart';
import '../domain/homework.dart';

class AddHomeworkScreen extends StatefulWidget {
  final Homework? homeworkToEdit;

  const AddHomeworkScreen({Key? key, this.homeworkToEdit}) : super(key: key);

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.homeworkToEdit != null) {
      _isEditing = true;
      final homework = widget.homeworkToEdit!;
      _subjectController.text = homework.subject;
      _titleController.text = homework.title;
      _descriptionController.text = homework.description;
      _dueDate = homework.dueDate;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveHomework() {
    if (_subjectController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final homework = Homework(
      id: _isEditing
          ? widget.homeworkToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      subject: _subjectController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      isCompleted: _isEditing ? widget.homeworkToEdit!.isCompleted : false,
    );

    if (_isEditing) {
      context.read<HomeworkBloc>().add(EditHomeworkEvent(homework));
    } else {
      context.read<HomeworkBloc>().add(AddHomeworkEvent(homework));
    }

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Homework' : 'Add Homework'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('Due Date'),
              subtitle: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _selectDate,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveHomework,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  _isEditing ? 'Update Homework' : 'Save Homework',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
