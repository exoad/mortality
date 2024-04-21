package pkg.exoad.mortality;
import javax.swing.*;

import java.awt.*;
public final class InfoDisplayRegion
	extends JPanel
{
	public InfoDisplayRegion()
	{
		setLayout(new GridLayout(1,3,8,0));
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
		appInfo.setAlignmentX(Component.CENTER_ALIGNMENT);
		JLabel basicStatsHeaders=new JLabel(
			"<html><strong>Hours lived\t</strong><br/><strong>Days tracked\t</strong></html>");
		basicStatsHeaders.setAlignmentX(Component.LEFT_ALIGNMENT);
		JLabel basicStatsAnswers=new JLabel(String.format(
			"<html>%.2f<br/>%d</html>",
			0F,
			AppGlobal.telemetry.value.allEntries().length
		));
		basicStatsAnswers.setAlignmentX(Component.RIGHT_ALIGNMENT);
		JPanel basicStatsWrapper=new JPanel()
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
				super.paintComponent(g);
			}
		};
		basicStatsWrapper.setBorder(BorderFactory.createLineBorder(
			Util.hexColor(AppGlobal.APP_COMPONENT_HIGHLIGHT_COLOR),
			18,
			true
		)); // this is making a padding like system (ie a hack)
		basicStatsWrapper.setOpaque(false);
		basicStatsWrapper.setLayout(new BorderLayout());
		basicStatsWrapper.add(basicStatsHeaders,BorderLayout.WEST);
		basicStatsWrapper.add(basicStatsAnswers,BorderLayout.EAST);
		appInfoWrapper.add(appInfo,BorderLayout.CENTER);
		JPanel moreStatsWrapper=new JPanel()
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
				super.paintComponent(g);
			}
		};
		moreStatsWrapper.setOpaque(false);
		JLabel moreStats=new JLabel();
		add(appInfoWrapper);
		add(moreStatsWrapper);
		add(basicStatsWrapper);
	}
}
