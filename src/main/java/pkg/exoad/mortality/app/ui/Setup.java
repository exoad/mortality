package pkg.exoad.mortality.app.ui;
import javax.swing.*;
import javax.swing.text.AbstractDocument;
import pkg.exoad.mortality.AppGlobal;
import pkg.exoad.mortality.app.*;

import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.*;
import java.util.function.Consumer;
import java.util.stream.IntStream;
public class Setup
{
	private final JFrame jf;
	private final JComboBox<String> month;
	private JComboBox<Integer> date;
	
	public Setup(Runnable onCancel,Consumer<MortalityTelemetry> onSubmit)
	{
		boolean setupComplete=false;
		jf=new JFrame("Setup Mortality");
		jf.addWindowListener(new WindowAdapter()
		{
			@Override public void windowClosing(final WindowEvent e)
			{
				SwingUtilities.invokeLater(
					new ConfirmContext(
						"Leaving the setup process will close the Mortality app",
						"Are you sure?",
						()->System.exit(0),
						()->{},
						jf
					));
			}
		});
		jf.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
		jf.setIconImage(Assets.loadImageIcon("app_icon.png"));
		jf.setPreferredSize(new Dimension(AppGlobal.SETUP_WIDTH,AppGlobal.SETUP_HEIGHT));
		jf.setSize(jf.getPreferredSize());
		JScrollPane jsp=new JScrollPane();
		jsp.setPreferredSize(jf.getPreferredSize());
		jsp.setBorder(BorderFactory.createEmptyBorder());
		jsp.setViewportBorder(BorderFactory.createEmptyBorder());
		JPanel contentPane=new JPanel();
		contentPane.setSize(new Dimension(
			AppGlobal.SETUP_WIDTH-(2*AppGlobal.SETUP_CONTENT_PADDING),
			200
		));
		contentPane.setBorder(BorderFactory.createEmptyBorder(
			AppGlobal.SETUP_CONTENT_PADDING,
			AppGlobal.SETUP_CONTENT_PADDING,
			AppGlobal.SETUP_CONTENT_PADDING,
			AppGlobal.SETUP_CONTENT_PADDING
		));
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.PAGE_AXIS));
		JLabel title=new JLabel(
			"<html><p style=\"font-size:18px\"><strong>Welcome to Mortality!</strong></p><p style=\"font-size:10px\">Personalize the app providing the following information about yourself.</p></html>");
		title.setAlignmentX(Component.LEFT_ALIGNMENT);
		IconDelegate iconDelegate=new IconDelegate("wave.png",48,48);
		JPanel titleWrapper=new JPanel();
		titleWrapper.setDoubleBuffered(true);
		titleWrapper.setLayout(new FlowLayout(FlowLayout.LEFT,16,6));
		titleWrapper.add(iconDelegate);
		titleWrapper.add(title);
		contentPane.add(titleWrapper);
		contentPane.add(Box.createVerticalStrut(16));
		JTextArea userNameInput=new JTextArea();
		userNameInput.requestFocus();
		((AbstractDocument)userNameInput.getDocument()).setDocumentFilter(new TextInputFilter()
		{
			@Override public boolean accept(
				final FilterBypass fb,final int offset,final String str
			)
			{
				return str
						   .matches("^[A-Za-z0-9_.]+$")&&userNameInput
															 .getText()
															 .length()<30;
			}
		});
		userNameInput.setText(System
								  .getProperty("user.name")
								  .isEmpty()?"somebody":System.getProperty(
			"user.name"));
		userNameInput
			.getDocument()
			.putProperty("filterNewlines",Boolean.TRUE);
		contentPane.add(makePrompt(
			"Preferred Name",
			"How you want to be referred as in the app",
			userNameInput
		));
		JPanel birthDateInput=new JPanel();
		birthDateInput.setLayout(new FlowLayout(FlowLayout.LEFT,6,6));
		month=new JComboBox<>(Arrays
								  .stream(Month.values())
								  .map(x->Util.formalizeString(x.name()))
								  .toList()
								  .toArray(new String[0]));
		month.setSelectedIndex(0);
		date=new JComboBox<>(IntStream
								 .range(
									 1,
									 Util.lookupMonthStrForced(Objects
																   .requireNonNull(month
																					   .getSelectedItem())
																   .toString()).maxDate+1
								 )
								 .boxed()
								 .toList()
								 .toArray(new Integer[0]));
		month.addActionListener(ev->{
			birthDateInput.remove(date);
			date=new JComboBox<>(IntStream
									 .range(
										 1,
										 Util.lookupMonthStrForced(Objects
																	   .requireNonNull(
																		   month
																			   .getSelectedItem())
																	   .toString()).maxDate+1
									 )
									 .boxed()
									 .toList()
									 .toArray(new Integer[0]));
			birthDateInput.add(date,3);
			birthDateInput.revalidate();
		});
		JTextArea year=new JTextArea();
		((AbstractDocument)year.getDocument()).setDocumentFilter(new TextInputFilter()
		{
			@Override public boolean accept(
				final FilterBypass fb,final int offset,final String str
			)
			{
				return year
						   .getText()
						   .length()<4&&str.matches("^\\d+$");
			}
		});
		year.setText("2006");
		birthDateInput.add(new JLabel("Month")); //0
		birthDateInput.add(month); //1
		birthDateInput.add(new JLabel("Day")); //2
		birthDateInput.add(date); //3
		birthDateInput.add(new JLabel("Year")); //4
		birthDateInput.add(year); //5
		contentPane.add(Box.createVerticalStrut(10));
		contentPane.add(makePrompt(
			"Birth date",
			"So we know where to start...and end...",
			birthDateInput
		));
		contentPane.add(Box.createVerticalStrut(16));
		JPanel controllerButtons=new JPanel();
		controllerButtons.setLayout(new FlowLayout(FlowLayout.RIGHT,6,4));
		JButton setInfo=new JButton("<html><p><strong>Submit</strong></p></html>");
		setInfo.addActionListener(ev->{
			if(userNameInput.getText()==null||userNameInput //priority above "year" due to ui ordering
				.getText()
				.isEmpty())
				new InformContext(
					"A required field \"user name\" was left blank!",
					"Oops...",
					()->{},
					jf,
					"Ok",
					null,
					null
				).run();
			else if(year.getText()==null||year
				.getText()
				.isEmpty())
				new InformContext(
					"A required field \"year\" was left blank!",
					"Oops...",
					()->{},
					jf,
					"Ok",
					null,
					null
				).run();
			else
			{
				jf.dispose();
				Calendar c=new GregorianCalendar();
				c.set(
					Integer.parseInt(year.getText()),
					Util.lookupMonthStrForced(
						month
							.getSelectedItem()
							.toString()).numerical-1,
					//ignore error if suggesting to use Calendar dot something
					date.getSelectedIndex()+1
				);
				MortalityTelemetry obj=new MortalityTelemetry(
					userNameInput.getText(),
					c.getTime(),
					new ArrayList<>(),
					0d
				);
				Debugger.info("setup creates "+obj);
				onSubmit.accept(obj);
			}
		});
		setInfo.setForeground(Util.hexColor(AppGlobal.APP_THEME_BG_COLOR));
		setInfo.setBackground(Util.hexColor(AppGlobal.SCHEME_GREEN));
		JButton cancelInfo=new JButton("Get Me Outta Here!");
		cancelInfo.addActionListener(ev->{
			jf.dispose();
			onCancel.run();
		});
		controllerButtons.add(cancelInfo);
		controllerButtons.add(setInfo);
		contentPane.add(controllerButtons);
		JViewport jvp=new JViewport();
		jvp.setView(contentPane);
		jsp.setViewport(jvp);
		jf.setContentPane(jsp);
	}
	
	private static JComponent makePrompt(String title,String description,JComponent input)
	{
		JPanel promptPanel=new JPanel();
		promptPanel.setLayout(new BoxLayout(promptPanel,BoxLayout.Y_AXIS));
		JLabel titleLabel=new JLabel(
			"<html><p style=\"font-size:10px\"><strong>"+title+"</strong><br/>"+description+"</p></html>",
			SwingConstants.LEFT
		);
		JPanel titleWrapper=new JPanel();
		titleWrapper.setLayout(new BorderLayout());
		titleWrapper.add(titleLabel,BorderLayout.WEST);
		promptPanel.add(titleWrapper);
		promptPanel.add(input);
		promptPanel.add(Box.createHorizontalGlue());
		return promptPanel;
	}
	
	public void run()
	{
		Debugger.info("launching the setup page");
		jf.pack();
		jf.setLocationRelativeTo(null);
		jf.setVisible(true);
		jf.toFront();
	}
}