package pkg.exoad.mortality.app;
import javax.swing.*;

import java.util.ArrayList;
public class ChangeNotifier //name inspried by flutter's changenotifier :)
{
	private final ArrayList<Runnable> listeners;
	
	public ChangeNotifier()
	{
		listeners=new ArrayList<>();
	}
	
	public synchronized void subscribe(Runnable r)
	{
		listeners.add(r);
	}
	
	protected synchronized void dispose()
	{
		listeners.clear();
	}
	
	protected synchronized void notifyListeners()
	{
		AppGlobal.WORKER_2.submit(()->listeners.forEach(Runnable::run));
	}
	
	protected void notifyUIListeners()
	{
		listeners.forEach(SwingUtilities::invokeLater);
	}
}
