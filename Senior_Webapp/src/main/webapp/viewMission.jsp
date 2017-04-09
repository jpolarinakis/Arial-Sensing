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
    <a href="/loadMission.jsp">viewMissions</a>|
    <a href='<%= userService.createLogoutURL("/index.jsp", null) %>'>logout</a>|
    <%= user.getUserId() %>
</nav>
<%--
<p>mission ID: ${missionId}</p>
<p>data is uploaded: ${dataUploaded}</p>
<p>text of data: ${missionData}</p>
--%>
<p>Download drone mission file: <button id="missionDownloadButton" onclick="download('${missionFile}');">download</button></p>

<form action="/upload" method="post" enctype="multipart/form-data">
    input a data file to upload for this mission
    <input type="file" name="file" />
    <input type="hidden" name="id" value="${missionId}" />
    <input type="submit" />
</form>

<% if((Boolean)request.getAttribute("dataUploaded") == true){%>
<p>
<button id="graph_0">Graph 0</button><button id="graph_1">Graph 1</button>
</p>
<%}else{%>
<p>no data has been uploaded</p>
<%}%>
<script>
function download(paramValue){
    console.log("asdf2");
    var actionPath = "/download";
    var paramName = "file";
    var postForm = document.createElement("form");
    postForm.setAttribute("method", "post");
    postForm.setAttribute("action", actionPath);

    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", paramName);
    hiddenField.setAttribute("value", paramValue);
    console.log("asdf");
    postForm.appendChild(hiddenField);
    document.body.appendChild(postForm);
    postForm.submit();
}
function temp(){
    console.log("logggggg");
}
</script>
</body>
</html
