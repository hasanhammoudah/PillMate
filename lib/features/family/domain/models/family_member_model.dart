class FamilyMember {
  final String id;
  final String name;
  final String phone;
  final String relationship;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
  });

  FamilyMember copyWith({
    String? id,
    String? name,
    String? phone,
    String? relationship,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'relationship': relationship,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        relationship: json['relationship'] as String,
      );
}
