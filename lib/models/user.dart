// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:pawfect_care/models/profile.dart';
import 'package:pawfect_care/models/role.dart';

class User {
  final String email;
  final String name;
  final String? phone;
  final Profile profile;
  final String userId;
  final Role role;

  User({
    required this.email,
    required this.name,
    this.phone,
    required this.profile,
    required this.userId,
    this.role = Role.user,
  });

  User copyWith({
    String? email,
    String? name,
    String? phone,
    Profile? profile,
    String? userId,
    Role? role,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profile: profile ?? this.profile,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'profile': profile.toMap(),
      'userId': userId,
      'role': role.name,           // <-- save just 'user', 'vet', etc.
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      profile: Profile.fromMap(map['profile'] as Map<String, dynamic>),
      userId: map['userId'] as String,
      role: Role.values.firstWhere(
            (e) => e.name == map['role'],           // <-- compare to .name
        orElse: () => Role.user,                // optional safe default
      ),
    );
  }


  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(email: $email, name: $name, phone: $phone, profile: $profile, userId: $userId, role: $role)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.profile == profile &&
        other.userId == userId &&
        other.role == role;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        profile.hashCode ^
        userId.hashCode ^
        role.hashCode;
  }
}
