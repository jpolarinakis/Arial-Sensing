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

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;

import java.util.List;
public class ViewMissionServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        UserService userservice = UserServiceFactory.getUserService();
        User user = userservice.getCurrentUser();
        if(user == null){
            resp.sendRedirect("/login.jsp");
            return;
        }
        
        String missionString;
        String missionData;
        boolean isUploaded;

        String missionIdStr = req.getPathInfo();
        missionIdStr = missionIdStr.substring(1);
        Long missionId = Long.decode(missionIdStr);
        
        if(missionId != null){
            Key<Mission> queryKey = Key.create(Mission.class, missionId);
            List<MissionData> data = ObjectifyService.ofy()
                .load()
                .type(MissionData.class)
                .ancestor(queryKey)
                .list();
        
            MissionData mDataClass = data.get(0);
            missionString = mDataClass.getMissionScript();
            isUploaded = mDataClass.isDataUploaded();
            missionData = mDataClass.getData();
        }else{
            missionString = missionIdStr + " *** ";
            return;
        }
        
        req.setAttribute("missionId", missionIdStr);        
        req.setAttribute("missionFile", missionString);
        req.setAttribute("dataUploaded", isUploaded);
        req.setAttribute("missionData", missionData);
        RequestDispatcher dispatch = req.getRequestDispatcher("/viewMission.jsp");
        if(dispatch == null){
            return;
        }
        dispatch.forward(req, resp);
    }
}
