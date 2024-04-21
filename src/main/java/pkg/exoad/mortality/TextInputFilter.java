package pkg.exoad.mortality;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.DocumentFilter;
public abstract class TextInputFilter
	extends DocumentFilter
{
	@Override
	public void insertString(FilterBypass fb,int offset,String str,AttributeSet as) throws
																					BadLocationException
	{
		if(accept(fb,offset,str))
			super.insertString(fb,offset,str,as);
	}
	
	public abstract boolean accept(FilterBypass fb,int offset,String str);
	
	@Override
	public void replace(
		DocumentFilter.FilterBypass fb,int offset,int length,String text,
		AttributeSet attrs
	) throws
	  BadLocationException
	{
		if(accept(fb,offset,text))
			super.replace(fb,offset,length,text,attrs);
	}
}
