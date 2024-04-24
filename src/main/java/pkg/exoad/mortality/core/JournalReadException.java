package pkg.exoad.mortality.core;
public class JournalReadException
	extends RuntimeException
{
	public JournalReadException(String message)
	{
		super(message);
	}
	
	public JournalReadException(String message,Throwable cause)
	{
		super(message,cause);
	}
}
