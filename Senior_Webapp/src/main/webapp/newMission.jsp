<!DOCTYPE html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html lang="en">
  <head>
    <style>
       #map {
        height: 400px;
        width: 100%;
       }
    </style>
  </head>
  <body>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if(user == null){
        response.sendRedirect("/login.jsp");
        return;
    }
%>

<nav>
    <a href="/newMission.jsp">addMission</a>|
    <a href="/loadMission.jsp">viewMissions</a>|
    <a href='<%= userService.createLogoutURL("/index.jsp", null) %>'>logout</a>|
    <%= user.getUserId() %>

</nav>


    <h3 id = "scriptTest">New Mission</h3>
    <div id="map"></div>
    <div>
        <p>Current Lat/Long Location of Marker is:</p>
        <p id = "LatLongPlace"></p>
        <button id = "updateButton" onclick="addNewLatLong()"> Add new position to script</button>
        <button id = "createScript" onclick= "createNewScript()">Generate Script</button>
    </div>
    <div id = "LatLongData"></div>

    <!-- HERE IS THE JAVASCRIPT -->
    <script>
    /*
    TODO:
    1) add listener to the changeable tables
    2) write a function that continually updates the currentScript
    OR
    1B) create function that looks through LatLongData and finds the relevent information
    -----------------------
    3) create a delete button functionally (by adding in the html in the addNewLatLong) 
    4) Implement delete button functionality
    */
    //var myLatLng = {lat: 30.2672, lng: -97.7431};
    var myLatLng = {lat: -35.363, lng: 149.165};
    var marker;
    var totalLatLongs;
    var currentScript;
    //Table variables                       
    var thLat = "<th> Latitude </th>";
    var thLong = "<th> Longitude </th>";
    var thHeight = "<th> Height </th>";
    var thHover = "<th> Hover Time </th>";
    var editTd = "<td contenteditable='true'>";
    var endTd = "</td>";
    var td = "<td>";
    var tr = "<tr>";
    var eTr = "</tr>";
    
function initMap() {
  
  totalLatLongs = 0;
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4,
    center: myLatLng
  });

    marker = new google.maps.Marker({
    position: myLatLng,
    map: map,
    draggable:true,
    title: 'marker'

  });
}
function addNewLatLong(){

    var initTable = '<table>';
    var endTable = '</table>';
    
    var tableHeader = '<tr> <th> Point Number </th> <th> Latitude </th> <th> Longitude </th> <th> Height </th> <th> Hover Time </th> </tr>';
    var html = "";
    document.getElementById("LatLongPlace").innerHTML = marker.position;

    if(totalLatLongs == 0){
      html = initTable + tableHeader;
    }
    else
    {
      html = document.getElementById("LatLongData").innerHTML;
      html = html.substring(0,html.length-8);
    }
    totalLatLongs = totalLatLongs + 1;
    var lat = marker.position.lat();
    var lng = marker.position.lng();

    html = html + " " + tr + td + totalLatLongs + endTd +  td + lat + endTd + td + lng + endTd + editTd + "400" + endTd + editTd + "0" + endTd +eTr;
    html = html + endTable;
    document.getElementById("LatLongData").innerHTML = html;
}

function createNewScript()
{

  var ret = "";
  var form = document.getElementById("LatLongData").innerHTML;
  var dot = "!";
  var blah = totalLatLongs;
  //first we remove the table headers
  var endOfTableHeader = "</tr>"
  var removeTableHeader = form.search(endOfTableHeader);
  form = form.substring(removeTableHeader+5,form.length);
  for(i = 0; i < totalLatLongs; i++)
  {
      var end = "</td>";
      var numPoint = form.search(end);
      form = form.substring(numPoint+5,form.length);
      ret = ret + "#";
      for(j = 0; j < 2; j++)
      {
        //find </td>, I know that <td> is at the beginning
        // therefore by knowing the beginning of the number, and the end, I know how long the number is and can parse it
        var endNum =  form.search('</td>');
        ret = ret + form.substring(4,endNum) + dot;
        form = form.substring(endNum+5,form.length);
      }
      for(j = 0;j < 2; j++)
      {
        var endNum =  form.search('</td>');
        ret = ret + form.substring(27,endNum) + dot;
        form = form.substring(endNum+5,form.length);
        if(j==1){
        	ret = ret.substring(0,ret.length-1);
      	}
      }
  }
  
  var actionPath = "/addmission";
  var paramName = "data";
  var postForm = document.createElement("form");
  postForm.setAttribute("method", "post");
  postForm.setAttribute("action", actionPath);

  var hiddenField = document.createElement("input");
  hiddenField.setAttribute("type", "hidden");
  hiddenField.setAttribute("name", paramName);
  hiddenField.setAttribute("value", ret);

  postForm.appendChild(hiddenField);
  document.body.appendChild(postForm);
  postForm.submit();

}

    </script>

<!-- HERE IS THE END OF THE JAVASCRIPT -->

    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCFYd7tmF3jdzQOgIZg5lhkR59YCpSGzcE&callback=initMap">
    </script>
    <script type="text/javascript">
      google.maps.event.addListener(map, 'click', function(event) {
   placeMarker(event.latLng);
});
      function placeMarker(location) {
    var marker = new google.maps.Marker({
        position: location, 
        map: map
    });
}
    </script>
  </body>
</html>
