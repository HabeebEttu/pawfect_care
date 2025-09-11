import 'dart:convert';

class Store {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });
  

  Store copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
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
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['zipCode'] as String,
      country: map['country'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.address == address &&
      other.city == city &&
      other.state == state &&
      other.zipCode == zipCode &&
      other.country == country;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode ^
      country.hashCode;
  }
}
