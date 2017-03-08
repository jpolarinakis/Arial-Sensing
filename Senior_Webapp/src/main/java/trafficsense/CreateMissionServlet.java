
package trafficsense;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Date;


import com.googlecode.objectify.ObjectifyService;

public class CreateMissionServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException{
        UserService userservice = UserServiceFactory.getUserService();
        User user = userservice.getCurrentUser();
        if(user == null){
            resp.sendRedirect("/login.jsp");
            return;
        }

        DroneOwner owner = new DroneOwner(user.getUserId());
        Mission addMission = new Mission(owner, new Date());
        MissionData addMissionData;

        String data = req.getParameter("data");

        ObjectifyService.ofy().save().entity(addMission).now();

        addMissionData = new MissionData(data, addMission);
        ObjectifyService.ofy().save().entity(addMissionData).now();

        resp.sendRedirect("/newMission.jsp");
        return;
    }
}
