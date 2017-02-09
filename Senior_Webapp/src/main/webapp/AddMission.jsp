
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
    <a href="/AddMission.jsp">addMission</a>|
    <a href="/ViewMission.jsp">viewMissions</a>|
    <a href='<%= userService.createLogoutURL("/login.jsp", null) %>'>logout</a>|
    <%= user.getUserId() %>

</nav>

<form action="/addmission" method="post">
    <div><textarea name="data" rows="1" cols="10"></textarea></div>
    <div><input type="submit" value="Create Mission" /></div>
</form>
</body>

</html>
