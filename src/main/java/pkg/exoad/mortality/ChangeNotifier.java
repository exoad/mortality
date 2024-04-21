package pkg.exoad.mortality;
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
		listeners.forEach(Runnable::run);
	}
	
	protected void notifyUIListeners()
	{
		listeners.forEach(SwingUtilities::invokeLater);
	}
}
