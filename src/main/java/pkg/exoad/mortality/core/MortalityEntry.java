package pkg.exoad.mortality.core;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;
public class MortalityEntry
	implements Serializable
{
	@Serial
	private static final long serialVersionUID=1L;
	public final long id;
	public final Date time; //what day this represents
	public String title; //a title for the day (can be empty)
	public String note; //like a personal diary the user might want to add u know
	public int rating; //guranteed from 0-10 (we hope)
	public ArrayList<MortalityEmotionTag> tags;
	
	public MortalityEntry(
		Date time,String title,String note,int rating,
		ArrayList<MortalityEmotionTag> tags
	)
	{
		this.id    =UUID
			.randomUUID()
			.timestamp();
		this.time  =time;
		this.title =title;
		this.note  =note;
		this.rating=rating;
		this.tags  =tags;
	}
	
	@Override
	public String toString()
	{
		return String.format("Entry[%d]\n{\n\tTime=%s\nTitle=%s\nNote=%s\nRating=%d/10\n");
	}
}
