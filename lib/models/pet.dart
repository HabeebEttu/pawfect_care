// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pawfect_care/models/gender.dart';

class Pet {
  String petId;
  String userId;
  String name;
  String species;
  int age;
  String photoUrl;
  Gender gender;
  bool isVaccinated;
  bool? isSpayed;
  bool? isNeutered;
  bool? isSpecialNeeds;
  Pet({
    required this.petId,
    required this.userId,
    required this.name,
    required this.species,
    required this.age,
    required this.photoUrl,
    required this.gender,
    required this.isVaccinated,
    this.isSpayed,
    this.isNeutered,
    this.isSpecialNeeds,
  });

  Pet copyWith({
    String? petId,
    String? userId,
    String? name,
    String? species,
    int? age,
    String? photoUrl,
    Gender? gender,
    bool? isVaccinated,
    bool? isSpayed,
    bool? isNeutered,
    bool? isSpecialNeeds,
  }) {
    return Pet(
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      species: species ?? this.species,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      isSpayed: isSpayed ?? this.isSpayed,
      isNeutered: isNeutered ?? this.isNeutered,
      isSpecialNeeds: isSpecialNeeds ?? this.isSpecialNeeds,
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
      'gender': gender.toString(),
      'isVaccinated': isVaccinated,
      'isSpayed': isSpayed,
      'isNeutered': isNeutered,
      'isSpecialNeeds': isSpecialNeeds,
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
      gender: _genderFromString(map['gender'] as String),
      isVaccinated: map['isVaccinated'] as bool,
      isSpayed: map['isSpayed'] as bool?,
      isNeutered: map['isNeutered'] as bool?,
      isSpecialNeeds: map['isSpecialNeeds'] as bool?,
    );
  }
  static Gender _genderFromString(String status) {
    return Gender.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => Gender.male,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) =>
      Pet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pet(petId: $petId, userId: $userId, name: $name, species: $species, age: $age, photoUrl: $photoUrl, gender: $gender, isVaccinated: $isVaccinated, isSpayed: $isSpayed, isNeutered: $isNeutered, isSpecialNeeds: $isSpecialNeeds)';
  }

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;

    return other.petId == petId &&
        other.userId == userId &&
        other.name == name &&
        other.species == species &&
        other.age == age &&
        other.photoUrl == photoUrl &&
        other.gender == gender &&
        other.isVaccinated == isVaccinated &&
        other.isSpayed == isSpayed &&
        other.isNeutered == isNeutered &&
        other.isSpecialNeeds == isSpecialNeeds;
  }

  @override
  int get hashCode {
    return petId.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        species.hashCode ^
        age.hashCode ^
        photoUrl.hashCode ^
        gender.hashCode ^
        isVaccinated.hashCode ^
        isSpayed.hashCode ^
        isNeutered.hashCode ^
        isSpecialNeeds.hashCode;
  }
}
