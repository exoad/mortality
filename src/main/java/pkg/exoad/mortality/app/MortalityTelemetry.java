package pkg.exoad.mortality.app;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.function.Consumer;
public class MortalityTelemetry
	implements Serializable
{
	@Serial private static final long serialVersionUID=2L;
	private static MortalityTelemetry instance;
	private final transient StreamedChangeNotifier<Pair</*Entry-Action*/MortalityEntryAction,/*Entry-ID*/Long>> entriesNotifier;
	private final transient ChangeNotifier changeNotifier;
	private final ArrayList<Long> entryIDs; //using a long cuz fuck it (idt anyone going to live till 64bit int limit but who knows)
	private String userName;
	private Date birthDate;
	private double usageTimeInHours;
	
	public MortalityTelemetry(
		String userName,Date birthDate,ArrayList<Long> entryIDs,double usageTimeInHours
	)
	{
		this.birthDate       =birthDate;
		this.userName        =userName;
		this.usageTimeInHours=usageTimeInHours;
		this.entryIDs        =entryIDs;
		changeNotifier       =new ChangeNotifier();
		entriesNotifier      =new StreamedChangeNotifier<>();
		if(AppGlobal.APP_USE_LOGGER)
			entriesNotifier.subscribe(e->Debugger.info(
				"TelemetryEntries received op["+e.first.name()+"] for ID="+e.second));
	}
	
	public static MortalityTelemetry getEmpty()
	{
		return new MortalityTelemetry(
			"",
			new Date(System.currentTimeMillis()),
			new ArrayList<>(),
			0d
		);
	}
	
	@Override
	public String toString()
	{
		return "\n{\n\tUserName="+userName+"\n\tBirthDate="+Chrono.MONTHNAME_DATE_YEAR.format(
			birthDate)+"\n\tUsageTimeInHours="+usageTimeInHours()+"\n\tEntryIDs="+entryIDs.toString()+"\n}";
	}
	
	public double usageTimeInHours()
	{
		return usageTimeInHours;
	}
	
	public void subscribeToEntriesStream(
		final Consumer<Pair<MortalityEntryAction,Long>> fx
	) //delegating function
	{
		entriesNotifier.subscribe(fx);
	}
	
	public void subscribeToChangeStream(Runnable r)
	{
		changeNotifier.subscribe(r);
	}
	
	public void addEntry(long e)
	{
		if(!doesEntryExist(e))
		{
			entryIDs.add(e);
			entriesNotifier.notifyUIListeners(Pair.of(MortalityEntryAction.ADD,e));
		}
	}
	
	public boolean doesEntryExist(long e)
	{
		return entryIDs.contains(e);
	}
	
	public long[] allEntries() //expensive method
	{
		long[] ids=new long[entryIDs.size()];
		for(int i=0;i<entryIDs.size();i++)
			ids[i]=entryIDs.get(i);
		return ids;
	}
	
	public void removeEntry(long e)
	{
		if(!doesEntryExist(e))
		{
			entryIDs.remove(e);
			entriesNotifier.notifyUIListeners(Pair.of(MortalityEntryAction.REMOVE,e));
		}
	}
	
	public String userName()
	{
		return userName;
	}
	
	public void setUsageTimeInHours(double n)
	{
		assert n>=0;
		usageTimeInHours=n;
		changeNotifier.notifyUIListeners();
	}
	
	public void setUserName(String userName)
	{
		this.userName=userName;
		changeNotifier.notifyUIListeners();
	}
	
	public Date getBirthDate()
	{
		return birthDate;
	}
	
	public void setBirthDate(Date birthDate)
	{
		this.birthDate=birthDate;
		changeNotifier.notifyUIListeners();
	}
}
