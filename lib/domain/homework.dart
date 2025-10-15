class Homework {
  String id;
  String subject;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Homework && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}