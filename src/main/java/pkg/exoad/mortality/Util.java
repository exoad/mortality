package pkg.exoad.mortality;
import javax.swing.*;

import java.awt.*;
import java.io.*;
import java.util.Objects;
import java.util.Optional;
public final class Util
{
	private Util(){}
	
	public static Color hexColor(String hex)
	{
		if(hex.startsWith("#"))
			hex=hex.substring(1);
		return new Color(
			Integer.parseInt(hex.substring(0,2),16),
			Integer.parseInt(hex.substring(2,4),16),
			Integer.parseInt(hex.substring(4,6),16)
		);
	}
	
	public static Month lookupMonthStrForced(String monthName)
	{
		for(Month r: Month.values())
			if(r
				.name()
				.equalsIgnoreCase(monthName))
				return r;
		return Month.JANUARY;
	}
	
	public static String formalizeString(String v)
	{
		return v
				   .substring(0,1)
				   .toUpperCase()+v
				   .substring(1)
				   .toLowerCase();
	}
	
	public static void serializeObject(
		String path,Object value
	)
	{
		assert value!=null;
		try
		{
			FileOutputStream fos=new FileOutputStream(path);
			ObjectOutputStream oos=new ObjectOutputStream(fos);
			oos.writeObject(value);
		}catch(IOException e)
		{
			Debugger.info("Failed to write object (of type="+value
				.getClass()
				.getCanonicalName()+"), located at: "+path);
		}
	}
	
	public static String structurizeException(
		Throwable e
	) //this gets the entire stack trace even if they maybe internal and irrelevant
	{
		StringWriter sw=new StringWriter();
		PrintWriter pw=new PrintWriter(sw);
		e.printStackTrace(pw);
		return sw.toString();
	}
	
	@SuppressWarnings("unchecked") public static <A> Optional<A> deserializeObject(
		String path,A defaultObj
	)
	{
		boolean shouldReturnDefault=false;
		A obj=null;
		try
		{
			FileInputStream fis=new FileInputStream(path);
			ObjectInputStream ois=new ObjectInputStream(fis);
			obj=(A)ois.readObject();
		}catch(IOException|ClassNotFoundException e)
		{
			if(defaultObj!=null)
				Debugger.info("Failed to read object (of type="+defaultObj
					.getClass()
					.getCanonicalName()+"), located at: "+path);
			shouldReturnDefault=true;
		}
		return shouldReturnDefault?(defaultObj==null?Optional.empty():Optional.of(
			defaultObj)):obj==null?Optional.empty():Optional.of(
			obj);
	}
	
	public static void sleep(long ms,boolean canPanic)
	{
		try
		{
			Thread.sleep(ms);
		}catch(InterruptedException e)
		{
			if(canPanic) throw new RuntimeException(e);
		}
	}
	
	public static void debugComponent(
		final JComponent e
	) //this function shld not appear in production code
	{
		e.setBorder(BorderFactory.createLineBorder(new Color(
			AppGlobal
				.getRngInstance()
				.nextInt(256),
			AppGlobal
				.getRngInstance()
				.nextInt(256),
			AppGlobal
				.getRngInstance()
				.nextInt(256)
		),2,false)); //fuck rounded cuz it doesnt tell us exact pt of ref
	}
	
	public static Graphics2D makeCapable(Graphics2D g2)
	{
		g2.setRenderingHint(
			RenderingHints.KEY_ANTIALIASING,
			RenderingHints.VALUE_ANTIALIAS_ON
		);
		g2.setRenderingHint(
			RenderingHints.KEY_INTERPOLATION,
			RenderingHints.VALUE_INTERPOLATION_BILINEAR
		);
		g2.setRenderingHint(
			RenderingHints.KEY_COLOR_RENDERING,
			RenderingHints.VALUE_COLOR_RENDER_QUALITY
		);
		g2.setRenderingHint(
			RenderingHints.KEY_TEXT_ANTIALIASING,
			RenderingHints.VALUE_TEXT_ANTIALIAS_GASP
		);
		return g2;
	}
	
	/**
	 * This is a hack for padding and thus may or may not work
	 *
	 * @param e component
	 * @param side side
	 * @param amount how much
	 */
	public static void padSingle(JComponent e,final Side side,final int amount)
	{
		e=Objects.requireNonNull(e);
		switch(side)
		{
			case BOTTOM -> e.setBorder(BorderFactory.createEmptyBorder(
				0,
				amount,
				0,
				0
			));
			case TOP -> e.setBorder(BorderFactory.createEmptyBorder(amount,0,0,0));
			case LEFT -> e.setBorder(BorderFactory.createEmptyBorder(0,0,amount,0));
			case RIGHT -> e.setBorder(BorderFactory.createEmptyBorder(0,0,0,amount));
		}
	}
}
