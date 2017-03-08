package trafficsense;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.Date;
import java.util.ArrayList;
import java.util.StringTokenizer;

@Entity
public class MissionData{
    @Parent private Key<Mission> parentMission;
    @Id private Long id;

    private String DroneMissionScript;

    MissionData(){
        DroneMissionScript = "";
    }    
    
    MissionData(String scriptText, Mission p){
        DroneMissionScript = scriptText;
        parentMission = Key.create(Mission.class, p.getId());
    }

    public String getMissionScript(){
        //return DroneMissionScript;
        return convert(DroneMissionScript);
    }
    
    private static class MyPoint {
        public double x;
        public double y;
        double height;
        int go;
        public MyPoint(double x, double y)
        {
            this.x = x;
            this.y = y;
        }
        public MyPoint(double x, double y, double height, int go)
        {
            this.x =x;
            this.y = y;
            this.height = height;
            this.go = go;
        }
        public double getLat()
        {
            return x;
        }
        public double getLng()
        {
            return y;
        }
        public double getHgt()
        {
            return height;
        }
        public int getGo()
        {
            return go;
        }
    }

    private String convert(String message)
    {
        ArrayList<MyPoint> gps = translate(message);
        final String tab = "\t";
        final String zero = "0";
        final String one = "1";
        ArrayList<String> putStrings = new ArrayList<String>();
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
        String ret = "";
        for(int i = 0; i < putStrings.size(); i++)
            ret = ret + putStrings.get(i)+ "\n";
        return ret;
    }

    private ArrayList<MyPoint> translate(String message)
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
