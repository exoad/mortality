package pkg.exoad.mortality.util;
public class Pair<A,B>
{
	public A first;
	public B second;
	public Pair(A first,B second)
	{
		this.first =first;
		this.second=second;
	}
	
	public static <C,D> Pair<C,D> of(C first,D second)
	{
		return new Pair<>(first,second);
	}
}
