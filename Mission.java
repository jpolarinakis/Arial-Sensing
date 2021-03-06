import java.util.ArrayList;
import java.util.StringTokenizer;

//version 1.0

public class Mission {
	
	private String owner;
	private ArrayList<MyPoint> points;
	//placeholder until I know what the data is going to look like
	private ArrayList<String> data;
	
	public String convert(String message)
	{
		ArrayList<MyPoint> gps = translate(message);
		final String tab = "\t";
		final String zero = "0";
		final String one = "1";
		ArrayList<String> putStrings = new ArrayList<String>();
		String ret = "";
		putStrings.add("QGC WPL 110");
		for(int i = 0; i < gps.size(); i++)
		{
			String toAdd = "";
			toAdd += Integer.toString(i) + tab;
			if(i == 0)
				toAdd += Integer.toString(1);
			else
			{
				toAdd += Integer.toString(0);
			}
			toAdd+= tab + zero + tab + Integer.toString(16) + tab;
			for(int j=0; j < 4; j++)
				toAdd+= zero +tab;
			toAdd += Double.toString(gps.get(i).x) + tab;
			toAdd += Double.toString(gps.get(i).y) + tab;
			//we'll figure out height some other time, this is 300ft
			toAdd += gps.get(i).height + tab + gps.get(i).go;
			//from here we save the file wherever it needs to be saved
			putStrings.add(toAdd);
		}
		/*
		 * TODO: add download capabillity so user gets the script downloaded
		 *  	Current version prints out the script to the console
		 * */
		for(int i = 0; i <putStrings.size();i++)
			ret = ret + putStrings.get(i) + "\n";
		return ret;
		
	}
	public ArrayList<MyPoint> translate(String message)
	{
		// (lat..long..height..go)(...)
		ArrayList<MyPoint> ret = new ArrayList<MyPoint>();
		StringTokenizer st = new StringTokenizer(message, "#");
		while(st.hasMoreElements()){
			StringTokenizer splice = new StringTokenizer(st.nextToken(), "!");
			double lat = Double.valueOf(splice.nextToken());
			double lng = Double.valueOf(splice.nextToken());
			double height = Double.valueOf(splice.nextToken());
			int go = Integer.valueOf(splice.nextToken());
			MyPoint mp = new MyPoint(lat,lng,height,go);
			ret.add(mp);			
		}		
		return ret;
	}
	

}
