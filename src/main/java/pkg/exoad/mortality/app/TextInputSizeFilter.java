package pkg.exoad.mortality.app;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.DocumentFilter;

import java.awt.*;
public class TextInputSizeFilter
	extends DocumentFilter
{
	private final int maxCharacters;
	
	public TextInputSizeFilter(int maxChars)
	{
		maxCharacters=maxChars;
	}
	
	public void insertString(FilterBypass fb,int offs,String str,AttributeSet a)
		throws
		BadLocationException
	{
		
		if((fb
				.getDocument()
				.getLength()+str.length())<=maxCharacters)
		{
			super.insertString(fb,offs,str,a);
		}
		else
		{
			Toolkit
				.getDefaultToolkit()
				.beep();
		}
	}
	
	public void replace(FilterBypass fb,int offs,int length,String str,AttributeSet a)
		throws
		BadLocationException
	{
		
		if((fb
				.getDocument()
				.getLength()+str.length()
			-length)<=maxCharacters)
		{
			super.replace(fb,offs,length,str,a);
		}
		else
		{
			Toolkit
				.getDefaultToolkit()
				.beep();
		}
	}
}
