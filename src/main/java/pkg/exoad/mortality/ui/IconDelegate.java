package pkg.exoad.mortality.app.ui;
import javax.swing.*;
import pkg.exoad.mortality.app.Assets;
import pkg.exoad.mortality.app.Util;

import java.awt.*;
import java.awt.image.BufferedImage;
public class IconDelegate
	extends JPanel
{
	private final Image img;
	
	public IconDelegate(String path,int width,int height)
	{
		img=Assets
			.loadImageIcon(path)
			.getScaledInstance(width,height,
							   BufferedImage.SCALE_SMOOTH
			);
		setPreferredSize(new Dimension(width,height));
	}
	
	@Override
	public void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		Graphics2D g2=Util.makeCapable((Graphics2D)g);
		g2.drawImage(img,0,0,this);
		g2.dispose();
	}
}
