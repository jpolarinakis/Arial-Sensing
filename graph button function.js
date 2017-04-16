function generateChart(var type)
{
	var csvData = null//PLEASE CHANGE THIS TO GET THE DOWNLOADED CSV FILE
	var convertedData = convertCSV(csvData);   

    var ctx = document.getElementById("barChart");
    //var testExample = [65, 59, 80, 81, 56, 55, 40];
    //var 
    //var a
    var testExample;
    var axisData;
    if(type == false){
     testExample = generateChartData(convertedData);
     axisData = generateChartAxis(convertedData);
}
	else{
		testExample = generateImplementation(AlecData);
		axisData = generateImpAxis(AlecData);
	}
var data = {
    labels: axisData,
    datasets: [
        {
            label: "number of cars/ average velocity (mph)",
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            borderColor: 'rgba(255,99,132,1)',
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
}