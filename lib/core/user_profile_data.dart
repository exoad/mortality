import 'package:json_annotation/json_annotation.dart';
import 'package:mortality_app/core/mortality_core.dart';
import 'package:mortality_app/shared.dart';
import 'package:mortality_app/util/intf.dart';

part 'user_profile_data.g.dart';

final class UserProfileDefaults {
  UserProfileDefaults._();

  static const String defaultName = "Jane Wang";
  static const Sex defaultSex = Sex.female;
  static const bool defaultUseSexBasedCalculations = true;
  static const String boxName =
      "$kCanonicalAppIdentifier:user_profile";
}

@JsonSerializable()
final class UserProfile implements Versioned {
  @JsonKey(
      required: true, defaultValue: UserProfileDefaults.defaultName)
  final String name;
  @JsonKey(
      required: true, defaultValue: UserProfileDefaults.defaultSex)
  final Sex sex;
  @JsonKey(required: true)
  final DateTime birthDate;
  @JsonKey(
      required: true,
      defaultValue:
      UserProfileDefaults.defaultUseSexBasedCalculations)
  final bool defaultUseSexBasedCalculations;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile({required this.name,
    required this.sex,
    required this.defaultUseSexBasedCalculations,
    required this.birthDate}) {
    assert(name.isNotEmpty, "[FATAL] Name field supplied as empty");
    assert(birthDate.isBefore(DateTime.now()),
    "[FATAL] Birth date is in the future");
  }

  UserProfile.fromAge({required this.name,
    required this.sex,
    required this.defaultUseSexBasedCalculations,
    required int age})
      : birthDate =
  DateTime.now().subtract(Duration(days: age * 365)) {
    assert(name.isNotEmpty, "[FATAL] Name field supplied as empty");
    assert(age >= 0, "[FATAL] Age field supplied as negative");
  }

  int get age =>
      DateTime
          .now()
          .difference(birthDate)
          .inDays ~/ 365;

  @override
  int get version => 1;

  AgeClassification get ageClassification =>
      age < 18
          ? AgeClassification.child
          : age < 65
          ? AgeClassification.adult
          : AgeClassification.senior;

  int get ageGroup => age ~/ 10;

  Duration get livedFor => DateTime.now().difference(birthDate);
}