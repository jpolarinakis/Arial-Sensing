<html>
<head>
	<title>Landing Page</title>
	<script type="text/javascript"></script>
	<style>
.button {
    background-color: #87CEFA;
    border: none;
    color: white;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 8px 4px;
    cursor: pointer;
}
</style>
</head>
<body>
<p id = "helloText">Hello!</p>
<button id = "logoutButton" onclick = "logout()">Logout</button>
<br>
<button class = "button" id = "newMissionButton" onclick = "NMB()">New Mission</button>
<br>
<button class = "button" id = "savedMissionButton" onclick = "SMB()">Saved Mission(s)</button>
<br>
<button class = "button" id = "dataButton" onclick = "DB()">Data</button>
</body>
<!-- Below this line will be the necessary javascript code -->
<script type="text/javascript">
/*
TODO:
1) ADD CODE SO NMB LINKS THIS PAGE TO THE NEW MISSION PAGE
2) ADD CODE SO THE SMB LINKS THIS PAGE TO THE SAVED MISSION PAGE
3) ADD CODE SO THE DB LINKS THIS PAGE WITHT HE DATA PAGE
4) ADD CODE SO THE HELLOW TEXT GREETS WITH THE LOGGED IN USERNAME
5) ADD CODE TO LOGOUT USING THE GOOGLE DATASTORE
*/
function NMB()
{
	document.getElementById("newMissionButton").innerHTML = "This isn't done yet, but this is temp code";
}
function SMB()
{
	document.getElementById("savedMissionButton").innerHTML = "This isn't done yet, but this is temp code";
}
function DB()
{
	document.getElementById("dataButton").innerHTML = "This isn't done yet, but this is temp code";
}
function getUsername()
{
	document.getElementById("helloText").innerHTML = "This isn't done yet, but this is temp code";
}
function logout()
{
	document.getElementById("logoutButton").innerHTML = "This isn't done yet, but this is temp code";
}
</script>
</html>