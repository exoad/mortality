package pkg.exoad.mortality.core.ux;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.DocumentFilter;

import java.util.ArrayList;
public class TextInputChainFilter
	extends DocumentFilter
{
	
	private ArrayList<DocumentFilter> filters;
	private AttributeSet attr;
	
	public TextInputChainFilter()
	{
		filters=new ArrayList<>(25);
	}
	
	public void addFilter(DocumentFilter filter)
	{
		filters.add(filter);
	}
	
	public void removeFilter(DocumentFilter filter)
	{
		filters.remove(filter);
	}
	
	public void remove(DocumentFilter.FilterBypass fb,int offset,int length) throws
																			 BadLocationException
	{
		for(DocumentFilter filter: filters)
			filter.remove(fb,offset,length);
	}
	
	public void insertString(
		DocumentFilter.FilterBypass fb,int offset,String string,AttributeSet attr
	) throws
	  BadLocationException
	{
		for(DocumentFilter filter: filters)
			filter.insertString(fb,offset,string,attr);
	}
	
	public void replace(
		DocumentFilter.FilterBypass fb,int offset,int length,String text,
		AttributeSet attrs
	) throws
	  BadLocationException
	{
		for(DocumentFilter filter: filters)
			filter.replace(fb,offset,length,text,attrs);
	}
}
