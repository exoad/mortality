package pkg.exoad.mortality;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.function.Consumer;
public class MortalityTelemetry
	extends ChangeNotifier
	implements Serializable
{
	@Serial private static final long serialVersionUID=1L;
	private static MortalityTelemetry instance;
	private final StreamedChangeNotifier<Pair</*Entry-Action*/MortalityEntryAction,/*Entry-ID*/Long>> entriesNotifier;
	private final ArrayList<Long> entryIDs; //using a long cuz fuck it (idt anyone going to live till 64bit int limit but who knows)
	private String userName;
	private Date birthDate;
	
	public MortalityTelemetry(String userName,Date birthDate,ArrayList<Long> entryIDs)
	{
		this.birthDate =birthDate;
		this.userName  =userName;
		this.entryIDs  =entryIDs;
		entriesNotifier=new StreamedChangeNotifier<>();
		if(AppGlobal.APP_USE_LOGGER)
			entriesNotifier.subscribe(e->Debugger.info(
				"TelemetryEntries received op["+e.first.name()+"] for ID="+e.second));
	}
	
	public static MortalityTelemetry getEmpty()
	{
		return new MortalityTelemetry("",
									  new Date(System.currentTimeMillis()),
									  new ArrayList<>());
	}
	
	public void subscribeToEntriesStream(
		final Consumer<Pair<MortalityEntryAction,Long>> fx
	) //delegating function
	{
		entriesNotifier.subscribe(fx);
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
	
	public void setUserName(String userName)
	{
		this.userName=userName;
		notifyUIListeners();
	}
	
	public Date getBirthDate()
	{
		return birthDate;
	}
	
	public void setBirthDate(Date birthDate)
	{
		this.birthDate=birthDate;
		notifyUIListeners();
	}
}
