// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Location {
  final String address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.latitude,
    required this.longitude,
  });

  Location copyWith({
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return Location(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'] as String,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Location(address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;
  
    return 
      other.address == address &&
      other.city == city &&
      other.state == state &&
      other.zipCode == zipCode &&
      other.country == country &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return address.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode ^
      country.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
