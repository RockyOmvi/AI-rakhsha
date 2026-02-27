class TrustedContact {
  final String? id;
  final String name;
  final String phone;
  final String relation;

  const TrustedContact({
    this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'relation': relation,
  };

  factory TrustedContact.fromMap(String id, Map<String, dynamic> map) {
    return TrustedContact(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relation: map['relation'] ?? '',
    );
  }

  TrustedContact copyWith({String? id, String? name, String? phone, String? relation}) {
    return TrustedContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
    );
  }
}
