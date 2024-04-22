package pkg.exoad.mortality.app;
import javax.imageio.ImageIO;
import javax.swing.*;
import pkg.exoad.mortality.AppEntry;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;
public final class Assets
{
	private Assets(){}
	
	public static URL load(String path)
	{
		return AppEntry.class.getResource(path);
	}
	
	public static BufferedImage loadImageIcon(String path)
	{
		try
		{
			return ImageIO.read(new File("./assets/"+path));
		}catch(IOException e)
		{
			throw new RuntimeException(e);
		}
	}
	
	public static ImageIcon loadImageIcon2(String path)
	{
		return new ImageIcon("./assets/"+path);
	}
}
