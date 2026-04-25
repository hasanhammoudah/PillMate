class HealthCenter {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String specialty;

  const HealthCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.specialty,
  });

  HealthCenter copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? specialty,
  }) {
    return HealthCenter(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'phone': phone,
        'specialty': specialty,
      };

  factory HealthCenter.fromJson(Map<String, dynamic> json) => HealthCenter(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        phone: json['phone'] as String,
        specialty: json['specialty'] as String,
      );
}
