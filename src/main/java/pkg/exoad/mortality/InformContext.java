package pkg.exoad.mortality;
import javax.swing.*;

import java.awt.*;
import java.awt.datatransfer.StringSelection;
public class InformContext
	implements Runnable
{
	public final JFrame jf;
	private final JFrame relativeTo;
	
	public InformContext(
		String message,String title,Runnable onConfirm,JFrame relativeTo,
		String buttonLabel,
		JComponent secondary,String titleColor /*titleColor must be in hex*/
	)
	{
		jf=new JFrame(title+" ["+hashCode()+"]");
		jf.setUndecorated(false);
		jf.setIconImage(Assets.loadImageIcon("app_icon.png"));
		jf.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		this.relativeTo=relativeTo;
		JPanel contentPane=new JPanel();
		contentPane.setBorder(BorderFactory.createEmptyBorder(4,2,4,2));
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));
		JLabel titleLabel=new JLabel("<html><p style=\"font-size:12px;color:"+AppGlobal.APP_THEME_BG_COLOR+"\"><strong>"+title+"</strong></p></html>")
		{
			@Override
			public void paintComponent(Graphics g)
			{
				Graphics2D g2=Util.makeCapable((Graphics2D)g);
				g2.setColor(Util.hexColor(titleColor));
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
		titleLabel.setBorder(BorderFactory.createEmptyBorder(6,6,6,6));
		JLabel messageLabel=new JLabel("<html><p style=\"font-size:10px\">"+message+"</p></html>");
		JPanel labelsWrapper=new JPanel();
		labelsWrapper.setLayout(new BorderLayout());
		labelsWrapper.add(titleLabel,BorderLayout.NORTH);
		labelsWrapper.add(messageLabel,BorderLayout.SOUTH);
		contentPane.add(labelsWrapper);
		contentPane.setBorder(BorderFactory.createEmptyBorder(4,4,4,4));
		JButton yes=new JButton(buttonLabel);
		yes.addActionListener(ev->{
			jf.dispose(); //we call dispose first bc we dont know if the action is hogging (save with onNo)
			onConfirm.run();
		});
		if(secondary!=null)
		{
			contentPane.add(Box.createVerticalStrut(12));
			contentPane.add(secondary);
		}
		contentPane.add(Box.createVerticalStrut(12));
		JPanel yesButtonWrapper=new JPanel();
		yesButtonWrapper.requestFocus();
		yesButtonWrapper.setLayout(new BorderLayout());
		yesButtonWrapper.add(yes,BorderLayout.CENTER);
		contentPane.add(yesButtonWrapper);
		jf.setContentPane(contentPane);
	}
	
	public static InformContext errorVariant(String message,String detailed)
	{
		assert detailed!=null&&!detailed.isEmpty()&&!detailed.matches("\\s+"); //dont make empty shit
		JScrollPane jsp=new JScrollPane();
		jsp.setPreferredSize(new Dimension(360,180));
		jsp.setBorder(BorderFactory.createTitledBorder(
			BorderFactory.createLineBorder(Util.hexColor(
				AppGlobal.APP_COMPONENT_HIGHLIGHT_COLOR),1,true),
			"<html><p><em>Detailed Info</em></p></html>"
		));
		JEditorPane jep=new JEditorPane();
		jep.setContentType(Mime.html.rep);
		jep.setPreferredSize(jsp.getPreferredSize());
		jep.setBorder(BorderFactory.createEmptyBorder(4,4,4,4));
		jep.setFocusable(false);
		jep.setText("<html><p>"+detailed
			.replace("\n","<br/>")
			.replace("\t","&#9;")
			.replace(" ","&nbsp;")+"</p></html>");
		jep.setEditable(false);
		JViewport jvp=new JViewport();
		jvp.setPreferredSize(jsp.getPreferredSize());
		jvp.setView(jep);
		jsp.setViewport(jvp);
		JPanel jp=new JPanel();
		jp.setLayout(new BorderLayout());
		jp.add(jsp,BorderLayout.NORTH);
		JButton copy=new JButton("Copy error");
		copy.addActionListener(ev->Toolkit
			.getDefaultToolkit()
			.getSystemClipboard()
			.setContents(new StringSelection(detailed),null));
		jp.add(copy,BorderLayout.SOUTH);
		InformContext ctxt=new InformContext(
			message,
			"Something f*cked up...",
			()->System.exit(-1),
			null,
			"Ok",
			jp,
			AppGlobal.SCHEME_RED
		);
		ctxt.jf.setAlwaysOnTop(true);
		return ctxt;
	}
	
	@Override public void run()
	{
		Debugger.info("pushing new inform_ctxt["+hashCode()+"]");
		jf.pack();
		jf.setLocationRelativeTo(relativeTo);
		jf.setVisible(true);
		jf.toFront();
	}
}
