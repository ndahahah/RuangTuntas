class TaskModel {
  final String id;
  final String title;
  final String description;
  final String subject;
  final DateTime deadline;
  final bool isCompleted;

  const TaskModel({
    this.id = '',
    required this.title,
    this.description = '',
    required this.subject,
    required this.deadline,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      deadline: DateTime.parse(json['deadline'].toString()),
      isCompleted: json['is_completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'deadline': deadline.toIso8601String().split('T').first,
      'is_completed': isCompleted,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
