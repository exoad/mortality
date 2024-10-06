// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'name',
      'sex',
      'birthDate',
      'defaultUseSexBasedCalculations'
    ],
  );
  return UserProfile(
    name: json['name'] as String? ?? 'Jane Wang',
    sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.female,
    defaultUseSexBasedCalculations:
        json['defaultUseSexBasedCalculations'] as bool? ?? true,
    birthDate: DateTime.parse(json['birthDate'] as String),
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sex': _$SexEnumMap[instance.sex]!,
      'birthDate': instance.birthDate.toIso8601String(),
      'defaultUseSexBasedCalculations': instance.defaultUseSexBasedCalculations,
    };

const _$SexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
};
