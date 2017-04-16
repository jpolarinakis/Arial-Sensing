<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>

<html lang="en">

<head>
    <meta charset = "utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title></title>
    <!--<script src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.bundle.min.js" type="text/javascript"></script>
    <meta name="descripton" content ="">
    <!-- There's a few more metas that I'm choosing to ignore -->
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
<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
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
--%>
<p>text of data: ${missionData}</p>

<p>Download drone mission file: <button id="missionDownloadButton" onclick="download('${missionFile}');">download</button></p>

<form action='<%= blobstoreService.createUploadUrl("/upload") %>' method="post" enctype="multipart/form-data">
    input a data file to upload for this mission
    <input type="file" name="file" />
    <input type="hidden" name="id" value="${missionId}" />
    <input type="submit" />
</form>

<% if((Boolean)request.getAttribute("dataUploaded") == true){%>
<p>
<button id="graph_0">Graph 0</button><button id="graph_1">Graph 1</button>
</p>
<canvas id="barChart" height="50" width="50"></canvas>
<%}else{%>
<p>no data has been uploaded</p>
<%}%>
<script type="text/javascript">
/*
    var csvData = '${missionData}'
    csvData = convertCSV(csvData); 
    var ctx = document.getElementById("barChart");
    var axisData = generateImpAxis(csvData);
    var testExample = generateImplementation(csvData);

	var data = {
	    labels: axisData,
	    datasets: [
		{
		    label: "number of cars/second",
		    backgroundColor: 'rgba(255, 159, 64, 0.2)',
		    borderColor: 'rgba(255, 159, 64, 1)',
		    borderWidth: 1,
		    data: testExample,
		}
	    ]
	};

	    new Chart(ctx, {
	    type: "bar",
	    data: data,

	    options: {
		scales: {
		    xAxes: [{
		        stacked: true
		    }],
		    yAxes: [{
		        stacked: true
		    }]
		},
		maintainAspectRatio: false
	    }
	});
*/
   //GENERATE DATA AREA
       function generateChartData(dataset)
    {
     //1) get the time variation for the bar chart
     var endTime = dataset[dataset.length-1][2];
     var bucketTimeIncrement = (endTime - 0)/8;
     var buckets = [];
     
     for(i =0; i < dataset.length; i++)
     {
        var currentMaxTime = bucketTimeIncrement;
        var currentMinTime = 0;
        var j =-1;
        for( currentMinTime = 0; currentMinTime < endTime; currentMinTime+= bucketTimeIncrement)
        {
            j++;
            var current = dataset[i];
            //i changed current[2] to current[4]
            if( currentMaxTime <= current[4] && !(currentMaxTime < current[1]))
            {

                if(isNaN(buckets[j]))
                {
                    buckets[j]=1;
                }
                else{
                    buckets[j] = buckets[j]+1;
                }
                
            }
            currentMaxTime+=bucketTimeIncrement;
            
        }
     }
        for(k =0; k <buckets.length; k++)
        {
            if((isNaN(buckets[k])) || (buckets[k]==undefined) || (buckets[k] == null))
            {
               buckets[k] = 0;
            }
        }
        //at this point buckets is the correct output and is ready to be used  
        //this line will be used for generateImplementation...
        generateImplementation(dataset);
        return buckets;

    }
    function generateChartAxis(dataset)
    {
      //test data since I don't have actual data
          var axis = [];
          var endTime = dataset[dataset.length-1][4];//changed 2 to 4
          var timeIncrement = (endTime - 0)/8;
          var currentMaxTime = timeIncrement;
          var currentMinTime = 0;
          for(k = 0; currentMinTime <= endTime- timeIncrement; k++)
          {
            axis[k] = currentMinTime + "-" + currentMaxTime;
            currentMaxTime += timeIncrement;
            currentMinTime += timeIncrement;
          }
          return axis;

    } 
    function generateImpAxis(dataset)
    {
        var axis = [];
        var minMaxSpeed = findMinMax(dataset);
        var speedInc = (minMaxSpeed[1] - minMaxSpeed[0])/8;
        var cMinSpeed = minMaxSpeed[0];
        var cMaxSpeed = cMinSpeed + speedInc;
        for(k = 0; cMinSpeed <= minMaxSpeed[1]-speedInc; k++)
        {
            axis[k]= cMinSpeed + "-" + cMaxSpeed;
            cMaxSpeed += speedInc;
            cMinSpeed += speedInc;
        }
        /*
        for(k = 0; k < axis.length; k++)
        {
            console.log(axis[k]);
        }
        */
        return axis;
    }
    function generateImplementation(dataset)
    {
        
        var buckets = [];
        var minMax = findMinMax(dataset);//gets minimum and maximum speed
        var minSpeed = minMax[0];
        var maxSpeed =minMax[1];
        var delta = (maxSpeed-minSpeed)/8;
       //           console.log("time delta is: " + delta);
        var currentMinSpeed = minSpeed;
        var currentMaxSpeed = minSpeed;
        var j =0;
        for(currentMinSpeed = minSpeed; currentMinSpeed < maxSpeed; currentMinSpeed+=delta) {//for  all the speed increments
            currentMaxSpeed += delta;
            for(k = 0; k < dataset.length; k++) { //for all the individual datapoints    
                //console.log("this speed is: " + dataset[k][3]);
            if(currentMinSpeed <= dataset[k][7] && dataset[k][7] < currentMaxSpeed)
            {
                if((isNaN(buckets[j])) || (buckets[j]==undefined) || (buckets[j] == null)){                
                    buckets[j] = 1;
                   // console.log("generated a bucket");
                    }                
                else
                {
                    buckets[j]++;
                  //  console.log("added to a bucket");
                }
            }
        }
        j++;
        }
      //  console.log(buckets.length);
        for(j = 0; j < buckets.length; j++)
        {
             if((isNaN(buckets[j])) || (buckets[j]==undefined) || (buckets[j] == null)){                
                    buckets[j] = 0;
                    }   
        }
        /*
        for(i = 0; i < buckets.length; i++)
        {
            console.log("the bucket for " + i + " is: " + buckets[i]);
            //console.log(buckets[i]);
        }
        //debug only
        //generateImpAxis(dataset);
        */
        return buckets;

    }
    function findMinMax(dataset)
    {
        var ret = [450,-450];
        for(i =0; i < dataset.length; i++)
        {
            if( dataset[i][7] < ret[0])
            {
                ret[0] = dataset[i][7];
            }
            if( dataset[i][7] > ret[1])
            {
                ret[1] = dataset[i][7];
            }
        }
        console.log("min is: " + ret[0]);
        console.log("max is: " + ret[1]);

        return ret;
    }
    function convertCSV(csvText)
    {
        csvText = csvText + ",";
        var ret = [];
        var findMinPoint = csvText.search("Average Velocity");
        var data = csvText.substring(findMinPoint+17, csvText.length);
        var moreData = data.search(",");
        var spot = 0;
        while(moreData != "-1")
        {
            var add = [];
            moreData = data.search(",");
            for(i =0; i < 7; i++)
            {
                var toAdd = data.substring(0,moreData);
                add[i] = toAdd;
                data = data.substring(moreData+1,data.length);
                moreData = data.search(",");
            }
            var foo = data.search("\n");
            if( foo != -1){
            var toAdd = data.substring(0,foo);
            add[7] = toAdd;
            data = data.substring(foo+1,data.length);
            moreData = data.search(",");
        }
        else{
            foo = data.search(",");
            var toAdd = data.substring(0,moreData);
            add[i] = toAdd;
            data = data.substring(moreData+1,data.length);
            moreData = data.search(",");
        }
            console.log(toAdd);
            

            ret[spot] = add;
            spot++;

        }
        return ret;
    }

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
