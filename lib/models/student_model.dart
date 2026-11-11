class StudentModel {
  final String name;
  final String studentId;
  final String className;
  final String studyProgram;
  final String university;

  const StudentModel({
    required this.name,
    required this.studentId,
    required this.className,
    required this.studyProgram,
    required this.university,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      studyProgram: json['study_program']?.toString() ?? '',
      university: json['university']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'student_id': studentId,
      'class_name': className,
      'study_program': studyProgram,
      'university': university,
    };
  }
}
