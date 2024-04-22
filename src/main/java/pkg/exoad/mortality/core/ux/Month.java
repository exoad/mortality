package pkg.exoad.mortality.core.ux;
public enum Month //we dont handle edge cases around here for leap years (nuh uh)
{
	JANUARY(1,31),
	FEBRUARY(2,29),
	MARCH(3,31),
	APRIL(4,30),
	MAY(5,31),
	JUNE(6,30),
	JULY(7,31),
	AUGUST(8,31),
	SEPTEMBER(9,30),
	OCTOBER(10,31),
	NOVEMBER(11,30),
	DECEMBER(12,31);
	
	public final int numerical;
	public final int maxDate;
	
	Month(int n,int maxDate)
	{
		this.numerical=n;
		this.maxDate  =maxDate;
	}
}
