package pkg.exoad.mortality.app.ui;
import javax.swing.*;
import pkg.exoad.mortality.app.AppGlobal;
import pkg.exoad.mortality.app.Assets;

import java.awt.*;
public final class Window
	implements Runnable
{
	private static Window instance;
	private final JFrame jf;
	private final JPanel contentPane;
	
	private Window()
	{
		jf=new JFrame("Mortality");
		Dimension dim=new Dimension(AppGlobal.WINDOW_WIDTH,AppGlobal.WINDOW_HEIGHT);
		jf.setIconImage(Assets.loadImageIcon("app_icon.png"));
		jf.setPreferredSize(dim);
		jf.setSize(dim);
		contentPane=new JPanel();
		contentPane.setLayout(new BorderLayout());
		contentPane.setDoubleBuffered(true);
		contentPane.setPreferredSize(dim);
	}
	
	public static Window getInstance()
	{
		if(instance==null)
			instance=new Window();
		return instance;
	}
	
	public synchronized void addChild(JComponent comp)
	{
		contentPane.add(comp,BorderLayout.CENTER);
	}
	
	@Override public void run()
	{
		SwingUtilities.invokeLater(()->{
			jf.setContentPane(contentPane);
			jf.pack();
			jf.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
			jf.setLocationRelativeTo(null);
			jf.setVisible(true);
			jf.setAlwaysOnTop(true);
			jf.setAlwaysOnTop(false);
		});
	}
}
