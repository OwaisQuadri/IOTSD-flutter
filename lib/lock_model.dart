class Lock {
  final String lock_name;
  final bool status;

  Lock({required this.lock_name, required this.status});

  factory Lock.fromJson(Map<String, dynamic> json) {
    return Lock(
      lock_name: json['lock_name'] as String,
      status: json['status'] as bool,
    );
  }
}
