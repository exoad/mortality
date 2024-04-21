package pkg.exoad.mortality;
import javax.swing.*;

import java.awt.*;
public class ConfirmContext
	implements Runnable
{
	private final JFrame jf;
	private final JFrame relativeTo;
	
	public ConfirmContext(
		String message,String title,Runnable onYes,Runnable onNo,JFrame relativeTo
	)
	{
		jf=new JFrame(title+" ["+hashCode()+"]");
		jf.setUndecorated(true);
		jf.setIconImage(Assets.loadImageIcon("app_icon.png"));
		jf.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
		this.relativeTo=relativeTo;
		JPanel contentPane=new JPanel();
		contentPane.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));
		JLabel titleLabel=new JLabel("<html><p style=\"font-size:12px\"><strong>"+title+"</strong></p></html>");
		JLabel messageLabel=new JLabel("<html><p style=\"font-size:10px\">"+message+"</p></html>");
		JPanel labelsWrapper=new JPanel();
		labelsWrapper.setLayout(new BorderLayout());
		labelsWrapper.add(titleLabel,BorderLayout.NORTH);
		labelsWrapper.add(messageLabel,BorderLayout.SOUTH);
		labelsWrapper.setBorder(BorderFactory.createEmptyBorder(0,10,0,10));
		contentPane.add(labelsWrapper);
		JPanel controllerPanel=new JPanel();
		controllerPanel.setLayout(new FlowLayout(FlowLayout.CENTER,6,6));
		JButton yes=new JButton("Yes");
		yes.addActionListener(ev->{
			jf.dispose(); //we call dispose first bc we dont know if the action is hogging (save with onNo)
			onYes.run();
		});
		JButton no=new JButton("Cancel");
		controllerPanel.add(yes);
		controllerPanel.add(no);
		contentPane.add(Box.createVerticalStrut(12));
		contentPane.add(controllerPanel);
		no.addActionListener(ev->{
			jf.dispose();
			onNo.run();
		});
		jf.setContentPane(contentPane);
	}
	
	@Override public void run()
	{
		Debugger.info("pushing new confirm_ctxt["+hashCode()+"]");
		jf.pack();
		jf.setLocationRelativeTo(relativeTo);
		jf.setVisible(true);
		jf.toFront();
	}
}
