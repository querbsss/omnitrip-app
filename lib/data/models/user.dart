class UserModel {
  final String name;
  final String email;
  final String passwordEncoded;

  const UserModel({
    required this.name,
    required this.email,
    required this.passwordEncoded,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] as String,
        email: json['email'] as String,
        passwordEncoded: json['passwordEncoded'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'passwordEncoded': passwordEncoded,
      };
}
