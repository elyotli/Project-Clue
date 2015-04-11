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

function populateGraph(data){

	options = {
		animation 			: true,
		animationSteps		: 100,
		animationEasing 	: "easeOutQuart",
	}

	var ctx = $("#graph-canvas")[0].getContext("2d");
	var barChart = new Chart(ctx).Bar(data, options);

}