$(document).ready(function(){
	$('#search-button').on('click', function(event){
		event.preventDefault();
		var topic = 
		$.ajax({
			type	:"GET",
			url		:"/trends", 
			datatype:"json",
			data    : {
				topic: $('#search-text').val()
			},
			success :function(response){
				console.log(response);
				populateGraph(response);
			},
			error	:function(response){
				console.log(response);
			}
		})
	});



});

function populateGraph(response){
	var labels 	= [];
	var data 	= [];
	for(var i = 0; i<response.length; i++){
		labels.push(response[i].date);
		data.push(response[i].index);
	}
	var data = {
		labels: labels,
		datasets:[
			{
			fillColor: "rgba(225,0,0,1)",
			strokeColor: "rgba(225,0,0,1)",
			data: data
			}
		]
	}

	var options = {
		animation 			: true,
		animationSteps		: 100,
		animationEasing 	: "easeOutQuart",
		scaleShowGridLines  : false,
	}

	var ctx = $("#graph-canvas")[0].getContext("2d");
	var barChart = new Chart(ctx).Bar(data, options);

}