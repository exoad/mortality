package pkg.exoad.mortality;
import javax.swing.*;

import java.util.ArrayList;
import java.util.function.Consumer;
public class StreamedChangeNotifier<A>
{
	private final ArrayList<Consumer<A>> listeners;
	
	public StreamedChangeNotifier()
	{
		listeners=new ArrayList<>();
	}
	
	public synchronized void subscribe(Consumer<A> fx)
	{
		listeners.add(fx);
	}
	
	protected synchronized void dispose()
	{
		listeners.clear();
	}
	
	protected synchronized void notifyListeners(A value)
	{
		listeners.forEach(x->x.accept(value));
	}
	
	protected void notifyUIListeners(A value)
	{
		listeners.forEach(x->SwingUtilities.invokeLater(()->x.accept(value)));
	}
	
}
