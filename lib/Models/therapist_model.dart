import 'dart:io';
import 'package:hive/hive.dart';

part 'therapist_model.g.dart';

@HiveType(typeId: 0)
class TherapistModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gender;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String altPhone;

  @HiveField(4)
  String email;

  @HiveField(5)
  String clinic;

  @HiveField(6)
  String degrees;

  @HiveField(7)
  String bio;

  @HiveField(8)
  String experience;

  @HiveField(9)
  String specialization;

  @HiveField(10)
  String fees;

  @HiveField(11)
  List<String> documentPaths;

  @HiveField(12)
  String doctorIdPath;

  TherapistModel({
    required this.name,
    required this.gender,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.clinic,
    required this.degrees,
    required this.bio,
    required this.experience,
    required this.specialization,
    required this.fees,
    required this.documentPaths,
    required this.doctorIdPath,
  });
}
