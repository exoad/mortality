package pkg.exoad.mortality;
import java.text.SimpleDateFormat;
import java.util.Date;
public final class Chrono
{
	public static final SimpleDateFormat LOG_TIME_FORMAT=new SimpleDateFormat(
		"yyyy/MM/dd hh:mm:ss");
	
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
