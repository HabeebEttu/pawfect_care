// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pawfect_care/models/pet.dart';

class AnimalShelter {
  final String id;
  final String name;
  final List<Pet> animals;
  final List<AdoptionRecord> adoptionRecords;
  
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String contactPhone;
  final String contactEmail;
  AnimalShelter({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.contactPhone,
    required this.contactEmail,
  });

  AnimalShelter copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? contactPhone,
    String? contactEmail,
  }) {
    return AnimalShelter(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
    };
  }

  factory AnimalShelter.fromMap(Map<String, dynamic> map) {
    return AnimalShelter(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['zipCode'] as String,
      country: map['country'] as String,
      contactPhone: map['contactPhone'] as String,
      contactEmail: map['contactEmail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnimalShelter.fromJson(String source) =>
      AnimalShelter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AnimalShelter(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, contactPhone: $contactPhone, contactEmail: $contactEmail)';
  }

  @override
  bool operator ==(covariant AnimalShelter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode &&
        other.country == country &&
        other.contactPhone == contactPhone &&
        other.contactEmail == contactEmail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zipCode.hashCode ^
        country.hashCode ^
        contactPhone.hashCode ^
        contactEmail.hashCode;
  }
}
