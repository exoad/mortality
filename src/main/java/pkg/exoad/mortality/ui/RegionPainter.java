package pkg.exoad.mortality.app.ui;
import javax.swing.*;
import pkg.exoad.mortality.app.MortalityMood;
import pkg.exoad.mortality.app.Util;

import java.awt.*;
public class RegionPainter
	extends JPanel
{
	private MortalityMood mood;
	private String title;
	
	@Override
	public void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		Graphics2D g2=Util.makeCapable((Graphics2D)g);
		g2.dispose();
	}
}
