package pkg.exoad.mortality.core.ux;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
public final class Chrono
{
	public static final SimpleDateFormat LOG_TIME_FORMAT=new SimpleDateFormat(
		"yyyy/MM/dd hh:mm:ss");
	public static final SimpleDateFormat MONTHNAME_DATE_YEAR=new SimpleDateFormat("MMMM dd, yyyy",
																				  Locale.US);
	
	private Chrono(){}
	
	public static String formatLog()
	{
		return LOG_TIME_FORMAT.format(new Date(System.currentTimeMillis()));
	}
	
	public static Date now()
	{
		return new Date(System.currentTimeMillis());
	}
}
