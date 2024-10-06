enum CanonicalMonths {
  january("January"),
  february("February"),
  march("March"),
  april("April"),
  may("May"),
  june("June"),
  july("July"),
  august("August"),
  september("September"),
  october("October"),
  november("November"),
  december("December");

  final String monthName;

  const CanonicalMonths(this.monthName);
}

const int kChronos_DaysInWeek = 7;
const int kChronos_MonthsInYear = 52;
const int kChronos_DaysInYear = 365;
const int kChronos_AvgDaysInMonth = 30; // best estimate, its like 30.4
