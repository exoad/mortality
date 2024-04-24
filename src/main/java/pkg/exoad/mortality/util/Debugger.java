package pkg.exoad.mortality.util;
import pkg.exoad.mortality.AppGlobal;

import java.util.logging.Logger;
public final class Debugger
{
	private static Logger LOG;
	
	static
	{
		if(AppGlobal.APP_USE_LOGGER)
		{ //this check here might be useless
			LOG=Logger.getGlobal();
			System.setProperty(
				"java.util.logging.SimpleFormatter.format",
				"%5$s %n"
			); //a hack to get rid of the time and project name line in the console messages
		}
	}
	
	public static void info(String message)
	{
		if(AppGlobal.APP_USE_LOGGER)
			LOG.info(String.format("[%s] (i): %s",Chrono.formatLog(),message));
	}
	
	public static void warn(String message)
	{
		if(AppGlobal.APP_USE_LOGGER)
			LOG.warning(String.format("[%s] (!): %s",Chrono.formatLog(),message));
	}
	
	public static String getFormattedUserPlatformInfo()
	{
		StringBuilder sb=new StringBuilder("== User Platform Info ==\n");
		for(Object r: System
			.getProperties()
			.keySet())
			sb
				.append("\t")
				.append(r.toString())
				.append("=")
				.append(System.getProperty(r.toString()))
				.append("\n");
		sb
			.append("\tTimestamp=")
			.append(Chrono.formatLog())
			.append("\n");
		return sb
			.append("== END ==")
			.toString();
	}
}
