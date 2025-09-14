// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MedicalRecords {
  String petId;
  String title;
  String desc;
  DateTime dateTime;
  MedicalRecords({
    required this.petId,
    required this.title,
    required this.desc,
    required this.dateTime,
  });

  MedicalRecords copyWith({
    String? petId,
    String? title,
    String? desc,
    DateTime? dateTime,
  }) {
    return MedicalRecords(
      petId: petId ?? this.petId,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'petId': petId,
      'title': title,
      'desc': desc,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory MedicalRecords.fromMap(Map<String, dynamic> map) {
    return MedicalRecords(
      petId: map['petId'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalRecords.fromJson(String source) => MedicalRecords.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedicalRecords(petId: $petId, title: $title, desc: $desc, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant MedicalRecords other) {
    if (identical(this, other)) return true;
  
    return 
      other.petId == petId &&
      other.title == title &&
      other.desc == desc &&
      other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return petId.hashCode ^
      title.hashCode ^
      desc.hashCode ^
      dateTime.hashCode;
  }
}
