import 'package:mortality_app/core/user_profile_data.dart';

import '../util/chronos.dart';

enum Sex {
  male,
  female;

  Duration get lifeExpectancy => switch (this) {
        male => kMC_DefaultMaleLifeExpectancy,
        female => kMC_DefaultFemaleLifeExpectancy
      };
}

enum AgeClassification {
  /// 0-17
  child,

  /// 18-64
  adult,

  /// 65 and older
  senior
}

final DateTime kMC_MockBirthDate = DateTime(2006, 08, 14);

const int kMC_DefaultLifeExpectancyInYears = 73;

const int kMC_DefaultFemaleLifeExpectancyInYears = 76;

const int kMC_DefaultMaleLifeExpectancyInYears = 71;

const Duration kMC_DefaultLifeExpectancy =
    Duration(days: kMC_DefaultLifeExpectancyInYears * kChronos_DaysInYear);

const Duration kMC_DefaultFemaleLifeExpectancy = Duration(
    days: kMC_DefaultFemaleLifeExpectancyInYears * kChronos_DaysInYear);

const Duration kMC_DefaultMaleLifeExpectancy =
    Duration(days: kMC_DefaultMaleLifeExpectancyInYears * kChronos_DaysInYear);

DateTime MC_RawExpectedDeath(DateTime birth) =>
    birth.add(kMC_DefaultLifeExpectancy);

DateTime MC_RawSexExpectedDeath(DateTime birth, Sex sex) =>
    birth.add(sex.lifeExpectancy);

Duration MC_timeLeft(UserProfile profile) =>
    Duration(
        days: (profile.defaultUseSexBasedCalculations
                ? profile.sex == Sex.male
                    ? kMC_DefaultMaleLifeExpectancyInYears
                    : kMC_DefaultFemaleLifeExpectancyInYears
                : kMC_DefaultLifeExpectancyInYears) *
            365) -
    profile.livedFor;
