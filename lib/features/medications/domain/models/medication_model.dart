class Medication {
  final String id;
  final String name;
  final String dosage;
  final List<String> scheduleTimes;
  final String startDate;
  final String endDate;
  final int remainingQuantity;
  bool takenToday;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.scheduleTimes,
    required this.startDate,
    required this.endDate,
    required this.remainingQuantity,
    this.takenToday = false,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    List<String>? scheduleTimes,
    String? startDate,
    String? endDate,
    int? remainingQuantity,
    bool? takenToday,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      takenToday: takenToday ?? this.takenToday,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'scheduleTimes': scheduleTimes,
        'startDate': startDate,
        'endDate': endDate,
        'remainingQuantity': remainingQuantity,
        'takenToday': takenToday,
      };

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        id: json['id'] as String,
        name: json['name'] as String,
        dosage: json['dosage'] as String? ?? '',
        scheduleTimes: List<String>.from(json['scheduleTimes'] as List),
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        remainingQuantity: (json['remainingQuantity'] as num).toInt(),
        takenToday: json['takenToday'] as bool? ?? false,
      );
}
