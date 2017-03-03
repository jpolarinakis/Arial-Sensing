package trafficsense;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/*
   This class serves as a parent to the mission class in the database
   It will also divide the collection of all missions into groups of
   missions who were done by the same user
*/
@Entity
public class DroneOwner {
    @Id private String username;

    DroneOwner(String name){
        username = name;
    }

    public String getName(){
        return username;
    }
}
