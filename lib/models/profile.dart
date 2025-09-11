// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Profile {
  final String? photoUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? bio;
  final String? uid;

  Profile({
    this.photoUrl,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.bio,
    this.uid,
  });

  Profile copyWith({
    String? photoUrl,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? bio,
    String? uid,
  }) {
    return Profile(
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'photoUrl': photoUrl,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'bio': bio,
      'uid': uid,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(photoUrl: $photoUrl, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, bio: $bio, uid: $uid)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;
  
    return 
      other.photoUrl == photoUrl &&
      other.address == address &&
      other.city == city &&
      other.state == state &&
      other.zipCode == zipCode &&
      other.country == country &&
      other.bio == bio &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return photoUrl.hashCode ^
      address.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zipCode.hashCode ^
      country.hashCode ^
      bio.hashCode ^
      uid.hashCode;
  }
}
