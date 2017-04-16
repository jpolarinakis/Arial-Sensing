package trafficsense;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DownloadMissionServlet extends HttpServlet {

    final String paramName = "file";
    
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	//get the text that the user wants
        String fileText = (String) req.getParameter(paramName);

        if(fileText == null){
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mission Text not present");
            return;
        }
        
        String fileName = "MissionFile.txt";
        
	//this just sets up the response, basically just telling the browser to treat it as a download
        resp.setContentType("text/plain");
        resp.setHeader("Content-disposition", "attachment; filename=\""+fileName+"\"");
        
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Expires", "-1");
        
        resp.getOutputStream().write(fileText.getBytes());
    }
}
