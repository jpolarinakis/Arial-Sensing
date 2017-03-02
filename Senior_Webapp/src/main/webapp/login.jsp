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
        String redirectURL = "/newMission.jsp";
        if(user != null){
            response.sendRedirect(redirectURL);
            return;
        }
    %>

    <div class= "container-fluid row">
    <div class="col-md-6">
    <img src="http://i.imgur.com/dyqxDf5.jpg" class="img-responsive" alt="Image of Traffic">
    </div>
    <div class="col-md-6 text-center">
        <h3 class="text-center">Welcome</h3>
        <a href='<%= userService.createLoginURL(redirectURL) %>' id="signin_btn" type="button" class="button btn btn-primary">Sign In</a>
    </div>
    </div>


    </body>
</html>
