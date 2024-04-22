package pkg.exoad.mortality.core;
import pkg.exoad.mortality.app.AppGlobal;
public enum MortalityMood
{
	GOOD("Good",AppGlobal.MOOD_GOOD_COLOR),DECENT("Decent",
												  AppGlobal.MOOD_DECENT_COLOR),HORRID(
	"Horrid",
	AppGlobal.MOOD_HORRID_COLOR),SPECIAL_1("Alpha",
										   AppGlobal.MOOD_SPECIAL_1_COLOR),SPECIAL_2(
	"Gamma",
	AppGlobal.MOOD_SPECIAL_2_COLOR),UNKNOWN("Unknown",AppGlobal.MOOD_UNKNOWN_COLOR);
	
	public final String displayName;
	public final String hexColor;
	
	MortalityMood(String displayName,String hexColor)
	{
		this.hexColor   =hexColor;
		this.displayName=displayName;
	}
}
