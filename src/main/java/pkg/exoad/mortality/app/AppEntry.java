package pkg.exoad.mortality.app;
import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import javax.swing.*;
import pkg.exoad.mortality.core.ux.Debugger;
import pkg.exoad.mortality.core.ux.NamedTask;
import pkg.exoad.mortality.core.ux.Util;
import pkg.exoad.mortality.core.MortalityEmotionTag;
import pkg.exoad.mortality.core.MortalityTelemetry;
import pkg.exoad.mortality.ui.Window;

import java.util.Arrays;
/**
 * Main
 *
 * @author Jack Meng
 */
public class AppEntry
{
	static final long start;
	
	static
	{
		start=System.currentTimeMillis();
	}
	
	public static void main(String... args)
	{
		long ephemeralStart=System.currentTimeMillis();
		for(String arg: args)
		{
			// this shit scuffed
			switch(arg)
			{
				case "--usegl" ->
				{
					Debugger.info("PROPERTY -> forceGL");
					System.setProperty("sun.java2d.opengl","True");
				}
				case "--nologging" ->
				{
					Debugger.info("PROPERTY -> loggingDisabled");
					AppGlobal.APP_USE_LOGGER=false;
				}
			}
			if(arg.startsWith("--savePeriod"))
			{
				long time=Long.parseLong(arg.split("=")[2]);
				Debugger.info("PROPERTY -> savePeriod="+time+"ms");
				AppGlobal.APP_SAVE_PERIOD=time;
			}
		}
		AppGlobal.WORKER_2.submit(()->{
			try
			{
				UIManager.setLookAndFeel(new FlatMacDarkLaf());
			}catch(UnsupportedLookAndFeelException e)
			{
				throw new RuntimeException(e);
			}
			Debugger.info(String.format(
				"starting mortality-app[%d]",
				AppGlobal.APP_VERSION_ID
			));
			Debugger.info("loaded possible emotion_tags="+Arrays
				.stream(MortalityEmotionTag.values())
				.map(x->Util.formalizeString(x.name()))
				.toList()
			);
			boolean shouldRunSetup=AppGlobal.load();
			if(shouldRunSetup)
			{
				new Setup(()->System.exit(0),telemetry->{
					Util.serializeObject(
						AppGlobal.APP_DIRECTORY+AppGlobal.PATH_SEPARATOR+AppGlobal.ENTRIES_MAIN_SAVE_FILE_NAME,
						telemetry
					);
					_run();
				})
					.run();
			}
			else
				_run();
			Debugger.info("app_Mortality_Hollistic STARTED UP IN "+(System.currentTimeMillis()-start)+"ms");
		});
		Debugger.info("app_Mortality_Ephemeral WARMED UP IN "+(System.currentTimeMillis()-ephemeralStart)+"ms");
	}
	
	private static void _run()
	{
		Splash
			.getInstance()
			.start(new NamedTask[]{
				new NamedTask(
					"Reading journal",
					()->Util
						.deserializeObject(
							AppGlobal.APP_DIRECTORY+AppGlobal.PATH_SEPARATOR+AppGlobal.ENTRIES_MAIN_SAVE_FILE_NAME,
							null
						)
						.ifPresentOrElse(
							t->{
								AppGlobal.telemetry.set((MortalityTelemetry)t);
								Debugger.info("telemetry model found");
								Debugger.info(t.toString());
							},
							()->{}
						)
				),
				new NamedTask(
					"Attach hook",
					()->Runtime
						.getRuntime()
						.addShutdownHook(new Thread(()->Debugger.info("bye bye...")))
				)
			},()->{
				Debugger.info("splash DONE");
				Debugger.info("telemetry loaded as "+AppGlobal.telemetry);
				JSplitPane jsp=new JSplitPane();
				jsp.setBorder(BorderFactory.createEmptyBorder());
				jsp.setOrientation(JSplitPane.VERTICAL_SPLIT);
				jsp.setDividerLocation(
					AppGlobal.WINDOW_HEIGHT/6);
				jsp.setTopComponent(new InfoDisplayRegion());
				jsp.setBottomComponent(new RegionPainter());
				Window
					.getInstance()
					.addChild(jsp);
				Window
					.getInstance()
					.run();
			});
	}
}
