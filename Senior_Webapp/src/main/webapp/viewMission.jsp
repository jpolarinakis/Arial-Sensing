<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

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
    <a href="/loadMission.jsp">loadMissions</a>|
    <a href='<%= userService.createLogoutURL("/index.jsp", null) %>'>logout</a>|
    <%= user.getUserId() %>
</nav>

<p>${missionFile}</p>

</body>
</html
