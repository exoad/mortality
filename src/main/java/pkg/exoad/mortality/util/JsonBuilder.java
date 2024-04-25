package pkg.exoad.mortality.util;
import java.util.HashMap;
import java.util.Map;
/**
 * A very naive Json Builder that can parse objects and
 * other values into a JSON String
 *
 * @author Jack Meng
 */
public final class JsonBuilder
{
	private final Map<String,Object> properties;
	
	private JsonBuilder()
	{
		properties=new HashMap<>();
	}
	
	public static JsonBuilder make()
	{
		return new JsonBuilder();
	}
	
	public static JsonValueType getAssociatedType(
		Object value
	)
	{
		return value==null?JsonValueType.str_t:
			value instanceof String?JsonValueType.str_t:
				value instanceof Float?
					JsonValueType.float_t:
					value instanceof Long?
						JsonValueType.long_t:
						value instanceof Boolean?
							JsonValueType.bool_t:
							value instanceof Float[]?
								JsonValueType.float_arr_t:
								value instanceof Long[]?
									JsonValueType.long_arr_t:value instanceof String[]?JsonValueType.str_arr_t:JsonValueType.str_t;
	}
	
	public <T> JsonBuilder add(String key,T value)
	{
		if(value==null)
			Debugger.panic(
				"JsonBuilder received [Null] value!",
				new NullPointerException()
			);
		else if(isValidType(value))
		{
			JsonValueType t=getAssociatedType(value);
			switch(t)
			{
				case str_t -> properties.put(key,"\""+value+"\"");
				case long_t,bool_t,float_t -> properties.put(key,value);
				case str_arr_t -> {
				
				}
				case long_arr_t -> {}
				case float_arr_t -> {}
			};
		}
		return this;
	}
	
	public static boolean isValidType(Object value)
	{
		return value instanceof String||value instanceof Float||value instanceof Long||value instanceof String[]||value instanceof Float[]||value instanceof Long[]||value instanceof Boolean;
	}
	
	public enum JsonValueType
	{
		str_t,long_t,float_t,bool_t,str_arr_t,long_arr_t,
		float_arr_t
	}
}
