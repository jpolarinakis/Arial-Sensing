
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="trafficsense.DroneOwner" %>
<%@ page import="trafficsense.Mission" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html lang="en">

<head>
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
    <a href="/viewMission.jsp">loadMissions</a>|
    <a href='<%= userService.createLogoutURL("/index.jsp", null) %>'>logout</a>|
    <%= user.getUserId() %>
</nav>

<%
    String userId = user.getUserId();
    Key<DroneOwner> queryKey = Key.create(DroneOwner.class, userId);
    
    List<Mission> missions = ObjectifyService.ofy()
        .load()
        .type(Mission.class)
        .ancestor(queryKey)
        .order("-date")
        .list();

    if(missions.isEmpty()){
%>
    <p>you haven't made any missions</p>
<%
    }else{
%>
    <h1>List of Missions:</h1>
<%
        for(Mission m : missions){
%>
    <p><b>Mission Date Created: <%= m.getDate().toString() %></b>
       <p> Data: <a href=<%="/viewmission/" + m.getId().toString()%>>load</a></p>
<%
        }
    }
%>



</body>
</html
