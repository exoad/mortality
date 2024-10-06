import 'package:mortality_app/util/chronos.dart';

extension UsefulDatetime on DateTime {
  Duration get toDuration => DateTime.now().difference(this);
}

extension UsefulDuration on Duration {
  double get inYears => inDays / kChronos_DaysInYear;

  double get inWeeks => inDays / kChronos_DaysInWeek;

  /// Not very accurate because we use an approximation for the avg days in months [kChronos_AvgDaysInMonth]
  double get inMonths => inDays / kChronos_AvgDaysInMonth;
}
