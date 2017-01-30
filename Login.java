package guestbook;
import java.util.ArrayList;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class Login {
	private DatastoreService ds;
	
	public Login(DatastoreService ds)
	{
		this.ds = ds;
		
	}
	/* *
	 * Key with access code "NumberOfUsers, 1" gives a key with the number of users
	 * @PARAM none
	 * @RETURN number of users, returns a -1 if there is an error (i.e. there are no users)
	 * */
	private int getNumberOfUsers()
	{
		Key retKey = KeyFactory.createKey("NumberOfUsers",1);
		Entity ret;
		try
		{
			ret = ds.get(retKey);
		} catch (EntityNotFoundException e) {
			return -1;
		}
		
		return Integer.valueOf((String) ret.getProperty("NumberOfUsers"));				
	}
	public boolean doLogin(String username, String password)
	{
		int numberOfUsers = getNumberOfUsers() + 1;
		for(int i = 1; i < numberOfUsers; i++)
		{
			Key key = KeyFactory.createKey("UserProfiles", i);
			Entity profile;
			try
			{
				profile = ds.get(key);
			} catch (EntityNotFoundException e) {
				return false;
			}
			String un = (String) profile.getProperty("username");
			String pw = (String) profile.getProperty("password");
			if(un.equals(username.toUpperCase()) && pw.equals(password.toUpperCase()) )
				return true;
		}
		return false;
		
		
	}

}
