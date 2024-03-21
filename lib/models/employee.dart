class Employee {
  final String name;
  final DateTime startDate;
  final bool isActive;

  Employee({
    required this.name,
    required this.startDate,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        name: json['name'],
        startDate: DateTime.parse(json['startDate']),
        isActive: json['isActive'],
      );
}
