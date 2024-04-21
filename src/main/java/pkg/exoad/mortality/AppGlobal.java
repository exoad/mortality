package pkg.exoad.mortality;
import java.io.File;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.atomic.AtomicReference;
/**
 * Shared constants class
 *
 * @author Jack Meng
 */
public final class AppGlobal
{
	public static final String APP_DISPLAY_NAME="Mortality";
	public static final int APP_VERSION_ID=1;
	public static final int WINDOW_HEIGHT=760;
	public static final int WINDOW_WIDTH=580;
	public static final int SPLASH_HEIGHT=280;
	public static final int SPLASH_WIDTH=640;
	public static final int SETUP_WIDTH=580;
	public static final int SETUP_HEIGHT=430;
	public static final int SETUP_CONTENT_PADDING=10;
	public static final int INFO_REGION_CONTENT_PADDING=10;
	public static final int INFO_REGION_CONTENT_LR_PADDING=INFO_REGION_CONTENT_PADDING+6;
	public static final String SCHEME_GREEN="#8cd64f";
	public static final String SCHEME_YELLOW="#d6b44f";
	public static final String SCHEME_RED="#d64f4f";
	public static final String APP_THEME_BG_COLOR="#1E1E1E";
	public static final String APP_COMPONENT_HIGHLIGHT_COLOR="#343434";
	public static final int UI_GENERAL_ROUNDNESS=6;
	public static final int SPLASH_CONTENT_PADDING_Y=22;
	public static final int SPLASH_CONTENT_PADDING_X=14;
	public static final String ENTRIES_MAIN_SAVE_FILE_NAME="index.bin";
	public static final String ENTRIES_FILE_NAME_FORMAT="Entry_%s.bin"; //here %s should be formatted like YYYY_MM_DD
	public static final String SPLASH_MESSAGE_HTML_FORMAT="<html><p style=\"font-size:11px\">\t%s</p></html>";
	public static final String SPLASH_PROGRESS_HTML_FORMAT="<html><p style=\"font-size:11px\"><strong>%d%%</strong></p></html>";
	public static boolean APP_USE_LOGGER=true;
	public static long APP_SAVE_PERIOD=10000L; //ms
	//mortality related metrics (the names are very self explanatory)
	public static int MORTALITY_EXPECTED_LIFETIME_IN_DAYS=29200; //editable by user
	public static String MOOD_GOOD_COLOR="#8cd64f"; //editable by user
	public static String MOOD_DECENT_COLOR="#d6b44f"; //editable by user
	public static String MOOD_HORRID_COLOR="#d64f4f"; //editable by user
	public static String MOOD_SPECIAL_1_COLOR="#4f97d6"; //editable by user
	public static String MOOD_SPECIAL_2_COLOR="#a181db"; //editable by user
	public static String MOOD_UNKNOWN_COLOR="#000000"; //editable by user
	//late init vars
	public static String PATH_SEPARATOR;
	public static String WORKING_DIRECTORY;
	public static String APP_DIRECTORY;
	public static AtomicReference<MortalityTelemetry> telemetry=new AtomicReference<>(null);
	
	private static Random rngInstance;
	
	private AppGlobal(){}
	
	public static Random getRngInstance()
	{
		if(rngInstance==null)
			rngInstance=new Random(System.currentTimeMillis());
		return rngInstance;
	}
	
	/**
	 * loads non const data for global
	 *
	 * @return whether or not a setup screen should be ran
	 */
	public static boolean load()
	{
		Debugger.info("Setting late global vars");
		PATH_SEPARATOR=System
			.getProperty("os.name")
			.contains("win")?"\\":"/";
		Debugger.info("path-separator set to "+PATH_SEPARATOR);
		File workDir=new File(System.getProperty("user.home"));
		WORKING_DIRECTORY=workDir.getAbsolutePath();
		Debugger.info("parent-work-dir="+WORKING_DIRECTORY);
		Debugger.info("Validate data-folder...");
		File appDir=new File(WORKING_DIRECTORY+PATH_SEPARATOR+".mortality_data");
		APP_DIRECTORY=appDir.getAbsolutePath();
		boolean isNewUser=true;
		if(!appDir.exists())
		{
			if(!appDir.mkdir())
				InformContext
					.errorVariant(
						"An internal error occurred",
						Util.structurizeException(new RuntimeException(String.format(
							"Failed to create appDir at %s",
							appDir.getAbsolutePath()
						)))
					)
					.run();
			else
				Debugger.info("created new mortality folder");
		}
		else if(!appDir.isDirectory())
		{
			appDir.delete();
			appDir.mkdir();
		}
		else
		{
			Debugger.info("returning user...");
			File mainSaveFile=new File(APP_DIRECTORY+PATH_SEPARATOR+ENTRIES_MAIN_SAVE_FILE_NAME);
			File entriesSubdir=new File(APP_DIRECTORY+PATH_SEPARATOR+"store");
			if(mainSaveFile.exists()&&entriesSubdir.exists())
			{
				isNewUser=false;
				Optional<MortalityTelemetry> e=Util
					.deserializeObject(
						APP_DIRECTORY+PATH_SEPARATOR+ENTRIES_MAIN_SAVE_FILE_NAME,
						null
					);
				AppGlobal.telemetry.set(e.orElse(null));
				if(AppGlobal.telemetry.get()==null)
					InformContext
						.errorVariant(
							"Failed to load journal!",
							Util.structurizeException(new JournalReadException(
								"Mortality's Journal could not be read due to an internally unhandled error. Crashing the app"))
						)
						.run();
			}
			else
				entriesSubdir.mkdir(); //true or false we dgaf
		}
		WORKING_DIRECTORY=appDir.getAbsolutePath();
		Debugger.info(String.format("app-dir located at %s",WORKING_DIRECTORY));
		Debugger.info("loaded telemetry as: "+telemetry.get());
		return isNewUser;
	}
}
