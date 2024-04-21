package pkg.exoad.mortality;
import java.util.logging.Logger;
public final class Debugger
{
	private static Logger LOG;
	
	static
	{
		if(AppGlobal.APP_USE_LOGGER) //this check here might be useless
			LOG=Logger.getGlobal();
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
}
