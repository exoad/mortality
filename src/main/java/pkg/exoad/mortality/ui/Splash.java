package pkg.exoad.mortality.ui;
import javax.swing.*;
import pkg.exoad.mortality.AppGlobal;
import pkg.exoad.mortality.util.*;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.concurrent.atomic.AtomicInteger;
public class Splash
{
	private static Splash instance;
	private final JFrame window;
	private final JLabel label;
	private final JLabel progressLabel;
	private final Image smallImage;
	private final JProgressBar progressBar;
	
	private Splash()
	{
		BufferedImage iconImage=Assets.loadImageIcon("app_icon.png");
		smallImage=iconImage.getScaledInstance(28,28,Image.SCALE_SMOOTH);
		window    =new JFrame();
		window.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE); //so the user doesnt fuck up initialization
		window.setUndecorated(true);
		progressBar=new JProgressBar(SwingConstants.HORIZONTAL,0,100);
		JLabel iconPanel=new JLabel(new ImageIcon(smallImage))
		{
			@Override
			public void paintComponent(Graphics g)
			{
				super.paintComponent(Util.makeCapable((Graphics2D)g));
				g.dispose();
			}
		};
		Util.debugComponent(iconPanel);
		JPanel contentPane=new JPanel();
		contentPane.setLayout(new BorderLayout());
		progressLabel=new JLabel(
			String.format(AppGlobal.SPLASH_PROGRESS_HTML_FORMAT,0),
			SwingConstants.CENTER
		)
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
				g2.dispose();
			}
		};
		label        =new JLabel(String.format(
			AppGlobal.SPLASH_MESSAGE_HTML_FORMAT,
			String.format("Warming up %s...",AppGlobal.APP_DISPLAY_NAME)
		),SwingConstants.CENTER)
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
				g2.dispose();
			}
		};
		label.setBorder(BorderFactory.createEmptyBorder(4,4,4,4));
		progressLabel.setBorder(BorderFactory.createEmptyBorder(0,4,0,4));
		JPanel progressLabelWrapper=new JPanel();
		progressLabelWrapper.setLayout(new BorderLayout());
		progressLabelWrapper.add(progressLabel);
		Util.padSingle(
			progressLabelWrapper,
			Side.RIGHT,
			10
		); // if we add padding directly with Util::padSingle we increase the width and thus increase highlight draw
		JPanel labelWrapper=new JPanel();
		labelWrapper.setLayout(new BorderLayout());
		labelWrapper.add(progressLabelWrapper,BorderLayout.WEST);
		labelWrapper.add(label,BorderLayout.EAST);
		contentPane.add(iconPanel,BorderLayout.WEST);
		contentPane.add(labelWrapper,BorderLayout.EAST);
		contentPane.setBorder(BorderFactory.createEmptyBorder(
			AppGlobal.SPLASH_CONTENT_PADDING_Y,
			AppGlobal.SPLASH_CONTENT_PADDING_X,
			AppGlobal.SPLASH_CONTENT_PADDING_Y,
			AppGlobal.SPLASH_CONTENT_PADDING_X
		));
		JPanel contentPaneWrapper=new JPanel();
		contentPaneWrapper.setLayout(new BorderLayout());
		contentPaneWrapper.add(contentPane,BorderLayout.NORTH);
		contentPaneWrapper.add(progressBar,BorderLayout.SOUTH);
		window.setIconImage(iconImage);
		window.setContentPane(contentPaneWrapper);
	}
	
	public static synchronized Splash getInstance()
	{
		if(instance==null) instance=new Splash();
		return instance;
	}
	
	public synchronized void start(NamedTask[] tasks,Runnable onDone)
	{
		assert tasks!=null&&tasks.length>0&&onDone!=null;
		show();
		Util.sleep(550L,false);
		for(AtomicInteger i=new AtomicInteger(0);i.get()<tasks.length;i.set(i.get()+1))
		{
			Debugger.info("splash_task -> running task #"+i+"["+tasks[i.get()]
				.task()
				.hashCode()+"] \""+tasks[i.get()].name()+"\"");
			updateProgress(
				(int)(((i.get()+1)/(tasks.length+1d))*100),
				tasks[i.get()].name()
			);
			tasks[i.get()]
				.task()
				.run();
		}
		updateProgress(100,"Launching...");
		Util.sleep(550L,false);
		onDone.run();
		dispose();
	}
	
	private void updateProgress(int progress,String message)
	{
		Debugger.info("splash_update_progress set to ["+progress+"%]");
		progressLabel.setText(String.format(
			AppGlobal.SPLASH_PROGRESS_HTML_FORMAT,
			progress
		));
		label.setText(String.format(AppGlobal.SPLASH_MESSAGE_HTML_FORMAT,message));
		progressBar.setValue(progress);
	}
	
	public synchronized void show()
	{
		Debugger.info("show_splash!");
		window.pack();
		window.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		window.setLocationRelativeTo(null); //makes it be at the center of the screen
		window.setVisible(true);
		window.toFront();
	}
	
	public synchronized void dispose()
	{
		window.toBack();
		window.setVisible(false);
		window.invalidate();
		window.dispose(); //deactivate and invalidate the window
	}
}
