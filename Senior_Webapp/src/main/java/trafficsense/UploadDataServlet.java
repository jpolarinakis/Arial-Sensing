package trafficsense;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import javax.servlet.ServletException;

import java.util.List;

import java.io.PrintWriter;
import java.io.InputStream;

import java.nio.file.Paths;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.servlet.RequestDispatcher;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
public class UploadDataServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
        PrintWriter out = resp.getWriter();
        String redirectURL;
        redirectURL = null;
        Long missionId = null;
        String missionDataStr = null;
        String missionString;
        try {
            List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(req);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();
                    
                    if(fieldName.equals("id")){
                        missionId = Long.decode(fieldValue);
                        redirectURL = "/viewmission/" + fieldValue;
                    }
                    
                    out.printf("%s : %s\n", fieldName, fieldValue);
                } else {
                    // Process form file field (input type="file").
                    String fieldName = item.getFieldName();
                    String fileName = FilenameUtils.getName(item.getName());
                    InputStream fileContent = item.getInputStream();
                    // ... (do your job here)
                    BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent));
                    StringBuilder sBuild= new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sBuild.append(line);
                    }


                    out.println(sBuild.toString());   //Prints the string content read from input stream
                    missionDataStr = sBuild.toString();
                    reader.close();
                }
            }
        } catch (FileUploadException e) {
            throw new ServletException("Cannot parse multipart request.", e);
        }


        if(missionDataStr != null && missionId != null && redirectURL != null){
                Key<Mission> queryKey = Key.create(Mission.class, missionId);
                List<MissionData> data = ObjectifyService.ofy()
                    .load()
                    .type(MissionData.class)
                    .ancestor(queryKey)
                    .list();
        
                MissionData mDataClass = data.get(0);
                mDataClass.setData(missionDataStr);
                out.println("save start");
                ObjectifyService.ofy().save().entity(mDataClass).now();
                out.println("save end");
            }else{
                out.println("something is null *** " + missionDataStr + " *** " + missionId + " *** " + redirectURL);
                missionString = "some value was null";
                return;
            }
        
        resp.sendRedirect(redirectURL);
        return;
    }
}
