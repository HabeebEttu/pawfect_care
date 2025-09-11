// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pet {
  String petId;
  String userId;
  String name;
  String species;
  int age;
  String photoUrl;
  String gender;
  Pet({
    required this.petId,
    required this.userId,
    required this.name,
    required this.species,
    required this.age,
    required this.photoUrl,
    required this.gender,
  });

  Pet copyWith({
    String? petId,
    String? userId,
    String? name,
    String? species,
    int? age,
    String? photoUrl,
    String? gender,
  }) {
    return Pet(
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      species: species ?? this.species,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'petId': petId,
      'userId': userId,
      'name': name,
      'species': species,
      'age': age,
      'photoUrl': photoUrl,
      'gender': gender,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      petId: map['petId'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      species: map['species'] as String,
      age: map['age'] as int,
      photoUrl: map['photoUrl'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) => Pet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pet(petId: $petId, userId: $userId, name: $name, species: $species, age: $age, photoUrl: $photoUrl, gender: $gender)';
  }

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;
  
    return 
      other.petId == petId &&
      other.userId == userId &&
      other.name == name &&
      other.species == species &&
      other.age == age &&
      other.photoUrl == photoUrl &&
      other.gender == gender;
  }

  @override
  int get hashCode {
    return petId.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      species.hashCode ^
      age.hashCode ^
      photoUrl.hashCode ^
      gender.hashCode;
  }
}
