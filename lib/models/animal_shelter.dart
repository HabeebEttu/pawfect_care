// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pawfect_care/models/adoption_record.dart';
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
  final double latitude;
  final double longitude;
  AnimalShelter({
    required this.id,
    required this.name,
    required this.animals,
    required this.adoptionRecords,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.contactPhone,
    required this.contactEmail,
    required this.latitude,
    required this.longitude,
  });

  AnimalShelter copyWith({
    String? id,
    String? name,
    List<Pet>? animals,
    List<AdoptionRecord>? adoptionRecords,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? contactPhone,
    String? contactEmail,
    double? latitude,
    double? longitude,
  }) {
    return AnimalShelter(
      id: id ?? this.id,
      name: name ?? this.name,
      animals: animals ?? this.animals,
      adoptionRecords: adoptionRecords ?? this.adoptionRecords,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'animals': animals.map((x) => x.toMap()).toList(),
      'adoptionRecords': adoptionRecords.map((x) => x.toMap()).toList(),
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AnimalShelter.fromMap(Map<String, dynamic> map) {
    return AnimalShelter(
      id: map['id'] as String,
      name: map['name'] as String,
      animals: List<Pet>.from((map['animals'] as List<int>).map<Pet>((x) => Pet.fromMap(x as Map<String,dynamic>),),),
      adoptionRecords: List<AdoptionRecord>.from((map['adoptionRecords'] as List<int>).map<AdoptionRecord>((x) => AdoptionRecord.fromMap(x as Map<String,dynamic>),),),
      address: map['address'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['zipCode'] as String,
      country: map['country'] as String,
      contactPhone: map['contactPhone'] as String,
      contactEmail: map['contactEmail'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnimalShelter.fromJson(String source) =>
      AnimalShelter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AnimalShelter(id: $id, name: $name, animals: $animals, adoptionRecords: $adoptionRecords, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, contactPhone: $contactPhone, contactEmail: $contactEmail, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant AnimalShelter other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      listEquals(other.animals, animals) &&
      listEquals(other.adoptionRecords, adoptionRecords) &&
      other.address == address &&
      other.city == city &&
      other.state == state &&
      other.zipCode == zipCode &&
      other.country == country &&
      other.contactPhone == contactPhone &&
      other.contactEmail == contactEmail &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      animals.hashCode ^
      adoptionRecords.hashCode ^
      address.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode ^
      country.hashCode ^
      contactPhone.hashCode ^
      contactEmail.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
