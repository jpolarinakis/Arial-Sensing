package trafficsense;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobstoreInputStream;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import javax.servlet.ServletException;

import java.util.List;
import java.util.Map;

import java.io.InputStream;

import java.io.BufferedReader;
import java.io.InputStreamReader;


public class UploadDataServlet extends HttpServlet {

    private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
	//basically the blobstore changes the request so that the file field is now a key that gives us access to the file
	//so we find all the blobkeys (there should only be 1)
	//and use it to get the file contents
	Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
        List<BlobKey> blobKeys = blobs.get("file");
	
	//we are redirecting to a specific mission (so invoking the viewMissionServlet)
	String redirectURL = null;

	//this is what we will be uploading
	String missionDataStr = null;

	//collect the mission id from the request
	String missionIdStr = req.getParameter("id");
	redirectURL = "/viewmission/" + missionIdStr;
	Long missionId = Long.decode(missionIdStr);

	if (blobKeys == null || blobKeys.isEmpty()) {
            //no file uploaded
        } else {
	    //file uploaded
	    
	    //get the blobKey then read its contents
	    BlobKey fileKey = blobKeys.get(0);
	    InputStream fileContent = new BlobstoreInputStream(fileKey);
	    BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent));
            StringBuilder sBuild= new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sBuild.append(line);
                sBuild.append("\\n");
            }

	    missionDataStr = sBuild.toString();
	    //dont forget these last 2 steps
	    reader.close();
	    blobstoreService.delete(fileKey);
        }

	if(missionDataStr != null && missionId != null && redirectURL != null){
	    //save the information from blob
            Key<Mission> queryKey = Key.create(Mission.class, missionId);
            List<MissionData> data = ObjectifyService.ofy()
                .load()
                .type(MissionData.class)
                .ancestor(queryKey)
                .list();
    
            MissionData mDataClass = data.get(0);
            mDataClass.setData(missionDataStr);

            ObjectifyService.ofy().save().entity(mDataClass).now();
  
        }else{
	    /* ideally this will never run, because some piece of information wasnt collected ot get here */
            //out.println("something is null *** " + missionDataStr + " *** " + missionId + " *** " + redirectURL);
            return;
        }

	resp.sendRedirect(redirectURL);
        return;

    }
}
