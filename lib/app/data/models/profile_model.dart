class ProfileModel {
  final int? id;
  String fullname;
  String email;
  String pass;

  ProfileModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.pass,
  });

  static ProfileModel fromMap(Map<String, dynamic> e) {
    return ProfileModel(
      id: e['id'],
      fullname: e['fullname'],
      email: e['email'],
      pass: e['pass'],
    );
  }

  ProfileModel copyWith({
    int? id,
    String? fullname,
    String? email,
    String? pass,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      pass: pass ?? this.pass,
    );
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'fullname': fullname, 'email': email, 'pass': pass};
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      pass: json['pass'],
    );
  }
}
