package pkg.exoad.mortality.ui;
import javax.swing.*;
import pkg.exoad.mortality.AppGlobal;
import pkg.exoad.mortality.util.Util;

import java.awt.*;
public final class InfoDisplayRegion
	extends JPanel
{
	public InfoDisplayRegion()
	{
		setLayout(new GridLayout(1,2,8,0));
		setBorder(BorderFactory.createEmptyBorder(
			AppGlobal.INFO_REGION_CONTENT_PADDING,
			AppGlobal.INFO_REGION_CONTENT_LR_PADDING,
			AppGlobal.INFO_REGION_CONTENT_PADDING,
			AppGlobal.INFO_REGION_CONTENT_LR_PADDING
		)); //acts like padding
		JPanel appInfoWrapper=new JPanel();
		appInfoWrapper.setBorder(BorderFactory.createEmptyBorder(0,8,0,0));
		appInfoWrapper.setLayout(new BorderLayout());
		JLabel appInfo=new JLabel(String.format(
			"<html><p style=\"font-size:16px\"><strong> %s</strong></p><p style=\"font-size:10px\">build v%d</p></html>",
			AppGlobal.APP_DISPLAY_NAME,
			AppGlobal.APP_VERSION_ID
		));
		appInfo.setDoubleBuffered(true);
		appInfo.setAlignmentX(Component.CENTER_ALIGNMENT);
		JLabel basicStatsHeaders=new JLabel(
			"<html><strong>Hours lived\t</strong><br/><strong>Days tracked\t</strong></html>");
		basicStatsHeaders.setAlignmentX(Component.LEFT_ALIGNMENT);
		JLabel basicStatsAnswers=new JLabel(String.format(
			"<html>%.2f<br/>%d</html>",
			0F,
			AppGlobal.telemetry
				.get()
				.allEntries().length
		));
		basicStatsAnswers.setAlignmentX(Component.RIGHT_ALIGNMENT);
		JPanel basicStatsWrapper=new JPanel()
		{
			@Override
			public void paintComponent(Graphics g)
			{
				g.setColor(Util.hexColor(AppGlobal.APP_COMPONENT_HIGHLIGHT_COLOR));
				g.fillRect(0,0,this.getWidth(),this.getHeight());
				super.paintComponent(g);
			}
		};
		basicStatsWrapper.setBorder(BorderFactory.createEmptyBorder());
		basicStatsWrapper.setDoubleBuffered(true);
		basicStatsWrapper.setOpaque(false);
		basicStatsWrapper.setLayout(new BorderLayout());
		basicStatsWrapper.add(basicStatsHeaders,BorderLayout.WEST);
		basicStatsWrapper.add(basicStatsAnswers,BorderLayout.EAST);
		appInfoWrapper.add(appInfo,BorderLayout.CENTER);
		JPanel basicStatsWrapperWrapper=new JPanel()
		{
			@Override
			public void paintComponent(Graphics g)
			{
				Graphics2D g2=Util.makeCapable((Graphics2D)g);
				g2.setColor(Util.hexColor(AppGlobal.APP_COMPONENT_HIGHLIGHT_COLOR));
				g2.fillRoundRect(
					0,
					0,
					getWidth(),
					getHeight(),
					AppGlobal.UI_GENERAL_ROUNDNESS,
					AppGlobal.UI_GENERAL_ROUNDNESS
				);
				super.paintComponent(g2);
			}
		};
		basicStatsWrapper.setOpaque(false);
		basicStatsWrapperWrapper.setLayout(new BorderLayout());
		basicStatsWrapperWrapper.add(basicStatsWrapper,BorderLayout.CENTER);
		basicStatsWrapperWrapper.setBorder(BorderFactory.createLineBorder(
			Util.hexColor(AppGlobal.APP_COMPONENT_HIGHLIGHT_COLOR),
			8,
			true
		)); // this is making a padding like system (ie a hack)
		JScrollPane jsp=new JScrollPane();
		jsp.setBorder(BorderFactory.createEmptyBorder());
		JViewport jvp=new JViewport();
		jvp.setView(basicStatsWrapperWrapper);
		jsp.setViewport(jvp);
		add(appInfoWrapper);
		add(jsp);
	}
}