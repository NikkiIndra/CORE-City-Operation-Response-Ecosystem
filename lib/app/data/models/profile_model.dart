class ProfileModel {
  final int? id;
  String fullname;
  String email;
  String pass;
  // final String mobilephone;
  // final String rt;
  // final String rw;
  // final String namaDesa;

  ProfileModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.pass,
    // required this.mobilephone,
    // required this.rt,
    // required this.rw,
    // required this.namaDesa,
  });

  static ProfileModel fromMap(Map<String, dynamic> e) {
    return ProfileModel(
      id: e['id'],
      fullname: e['fullname'],
      email: e['email'],
      pass: e['pass'],
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
