class Log {
  final String lock_name;
  final bool status;
  final String changed_by;
  final DateTime date;

  Log({
    required this.lock_name,
    required this.status,
    required this.changed_by,
    required this.date,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      lock_name: json['lock_name'] as String,
      status: json['status'] as bool,
      changed_by: json['changed_by'] as String,
      date: DateTime.parse(json['date']).toLocal(),
    );
  }
}
