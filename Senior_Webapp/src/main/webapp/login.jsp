<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html lang="en">
<head>
<title>Sign In Page</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<body>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if(user != null){
        response.sendRedirect("/landing_page.jsp");
        return;
    }
%>
<div class="container text-center">
<div class= "row">
<div class="col-sm-4">
<img src="http://i.imgur.com/dyqxDf5.jpg" class="img-circle img-responsive" alt="Image of Traffic">
</div>
<div class="col-sm-4 text-center">
    <h3 class="text-center">Welcome</h3>
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" id="signin_btn" type="button" class="button btn btn-primary">Sign In</a>
</div>
</div>
</div>

</body>
</html>
