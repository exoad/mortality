package pkg.exoad.mortality.util;
import javax.swing.*;
import pkg.exoad.mortality.AppGlobal;

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
	
	public synchronized void dispose()
	{
		listeners.clear();
	}
	
	public synchronized void notifyListeners(A value)
	{
		AppGlobal.WORKER_2.submit(()->listeners.forEach(x->x.accept(value)));
	}
	
	public void notifyUIListeners(A value)
	{
		listeners.forEach(x->SwingUtilities.invokeLater(()->x.accept(value)));
	}
	
}
