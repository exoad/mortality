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
  static final DateTime defaultBirthDate = DateTime(2006, 07, 14);
  static const String boxName = "$kCanonicalAppIdentifier:user_profile";
}

@JsonSerializable()
final class UserProfile implements Versioned {
  @JsonKey(
      name: "name",
      required: true,
      defaultValue: UserProfileDefaults.defaultName)
  String _name;
  @JsonKey(
      name: "sex", required: true, defaultValue: UserProfileDefaults.defaultSex)
  Sex _sex;
  @JsonKey(name: "birthDate", required: true)
  DateTime _birthDate;
  @JsonKey(
      name: "defaultUseSexBasedCalculations",
      required: true,
      defaultValue: UserProfileDefaults.defaultUseSexBasedCalculations)
  final bool _defaultUseSexBasedCalculations;

  String get name => _name;

  Sex get sex => _sex;

  DateTime get birthDate => _birthDate;

  bool get defaultUseSexBasedCalculations => _defaultUseSexBasedCalculations;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile(
      {required String name,
      required Sex sex,
      required bool defaultUseSexBasedCalculations,
      required DateTime birthDate})
      : _name = name,
        _sex = sex,
        _birthDate = birthDate,
        _defaultUseSexBasedCalculations = defaultUseSexBasedCalculations {
    assert(name.isNotEmpty, "[FATAL] Name field supplied as empty");
    assert(birthDate.isBefore(DateTime.now()),
        "[FATAL] Birth date is in the future");
  }

  UserProfile.fromAge(
      {required String name,
      required Sex sex,
      required bool defaultUseSexBasedCalculations,
      required int age})
      : _name = name,
        _sex = sex,
        _defaultUseSexBasedCalculations = defaultUseSexBasedCalculations,
        _birthDate = DateTime.now().subtract(Duration(days: age * 365)) {
    assert(name.isNotEmpty, "[FATAL] Name field supplied as empty");
    assert(age >= 0, "[FATAL] Age field supplied as negative");
  }

  int get age => DateTime.now().difference(_birthDate).inDays ~/ 365;

  @override
  int get version => 1;

  AgeClassification get ageClassification => age < 18
      ? AgeClassification.child
      : age < 65
          ? AgeClassification.adult
          : AgeClassification.senior;

  int get ageGroup => age ~/ 10;

  Duration get livedFor => DateTime.now().difference(_birthDate);

  @override
  int get hashCode => _name.hashCode ^ 31;

  @override
  bool operator ==(Object other) {
    if (other is UserProfile) {
      return other.name == name &&
          other.sex == sex &&
          other.birthDate == birthDate;
    }
    return false;
  }
}
