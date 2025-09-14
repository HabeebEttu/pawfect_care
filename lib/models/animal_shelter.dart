// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pawfect_care/models/adoption_record.dart';
import 'package:pawfect_care/models/location.dart';
import 'package:pawfect_care/models/pet.dart';

class AnimalShelter {
  final String id;
  final String name;
  final List<Pet> animals;
  final List<AdoptionRecord> adoptionRecords;
  final String contactPhone;
  final String contactEmail;
  final Location location;
  AnimalShelter({
    required this.id,
    required this.name,
    required this.animals,
    required this.adoptionRecords,
    required this.contactPhone,
    required this.contactEmail,
    required this.location,
  });

  AnimalShelter copyWith({
    String? id,
    String? name,
    List<Pet>? animals,
    List<AdoptionRecord>? adoptionRecords,
    String? contactPhone,
    String? contactEmail,
    Location? location,
  }) {
    return AnimalShelter(
      id: id ?? this.id,
      name: name ?? this.name,
      animals: animals ?? this.animals,
      adoptionRecords: adoptionRecords ?? this.adoptionRecords,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'animals': animals.map((x) => x.toMap()).toList(),
      'adoptionRecords': adoptionRecords.map((x) => x.toMap()).toList(),
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'location': location.toMap(),
    };
  }

  factory AnimalShelter.fromMap(Map<String, dynamic> map) {
    return AnimalShelter(
      id: map['id'] as String,
      name: map['name'] as String,
      animals: List<Pet>.from(
        (map['animals'] as List<dynamic>).map<Pet>(
          (x) => Pet.fromMap(x as Map<String, dynamic>),
        ),
      ),
      adoptionRecords: List<AdoptionRecord>.from(
        (map['adoptionRecords'] as List<dynamic>).map<AdoptionRecord>(
          (x) => AdoptionRecord.fromMap(x as Map<String, dynamic>),
        ),
      ),
      contactPhone: map['contactPhone'] as String,
      contactEmail: map['contactEmail'] as String,
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnimalShelter.fromJson(String source) =>
      AnimalShelter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AnimalShelter(id: $id, name: $name, animals: $animals, adoptionRecords: $adoptionRecords, contactPhone: $contactPhone, contactEmail: $contactEmail, location: $location)';
  }

  @override
  bool operator ==(covariant AnimalShelter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.animals, animals) &&
        listEquals(other.adoptionRecords, adoptionRecords) &&
        other.contactPhone == contactPhone &&
        other.contactEmail == contactEmail &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        animals.hashCode ^
        adoptionRecords.hashCode ^
        contactPhone.hashCode ^
        contactEmail.hashCode ^
        location.hashCode;
  }
}
