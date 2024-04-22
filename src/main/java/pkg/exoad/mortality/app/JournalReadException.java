package pkg.exoad.mortality.app;
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
