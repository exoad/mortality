package pkg.exoad.mortality.app;
public class Value<T>
{
	public T value;
	
	public Value(T value)
	{
		this.value=value;
	}
	
	public void set(T value)
	{
		this.value=value;
	}
	
	@Override
	public String toString()
	{
		return "Value="+value;
	}
}
