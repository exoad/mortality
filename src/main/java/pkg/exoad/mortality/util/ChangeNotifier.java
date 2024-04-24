package pkg.exoad.mortality.util;
import javax.swing.*;
import pkg.exoad.mortality.AppGlobal;

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
	
	public synchronized void dispose()
	{
		listeners.clear();
	}
	
	public synchronized void notifyListeners()
	{
		AppGlobal.WORKER_2.submit(()->listeners.forEach(Runnable::run));
	}
	
	public void notifyUIListeners()
	{
		listeners.forEach(SwingUtilities::invokeLater);
	}
}
