package pkg.exoad.mortality.faker;
import pkg.exoad.mortality.MortalityTelemetry;

import java.util.ArrayList;
import java.util.Date;
public class TestSerializableFaker
{
	public static final MortalityTelemetry r=new MortalityTelemetry("John Doe",
																	new Date(System.currentTimeMillis()),new ArrayList<>()
	);
}
