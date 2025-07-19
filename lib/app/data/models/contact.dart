class ContactModel {
  final String? name;
  final String category;
  final String? phone;
  final String? location;

  ContactModel({
    required this.name,
    required this.category,
    required this.phone,
    required this.location,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    name: json['name'],
    category: json['category'],
    phone: json['phone'],
    location: json['location'],
  );
}
