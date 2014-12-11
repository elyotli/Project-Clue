function updateGraph(dataArray, canvasData){
	// set up the data
	var canvas = canvasData.canvas,
		yScale = canvasData.yScale,
		graphHeight = canvasData.graphHeight,
		graphWidth = canvasData.graphWidth;

	var dataNSize = dataArray.length,
		barSize = graphWidth / dataNSize;

	var bars = canvas.selectAll("rect")
					.data(dataArray)
					.enter()
						.append("rect")
						.attr("width", barSize)
						.attr("height", 0) 
						.attr("fill", "navy")
						.attr("y", function(d, i){
							return graphHeight;//starting from top down, so graphHeight is all the way at the bottom
						})
						.attr("x", function(d, i){
							return barSize * i;
						});

	var xScale = d3.time.scale()
	        	.domain([mindate, maxdate])
				.range([padding, width - padding * 2]);

	var xAxis = d3.svg.axis()
				.ticks(5)
				.scale(xScale);

	bars.transition()
		.duration(500)
		.attr("y", function(d){
			return graphHeight - yScale(d);
		})
		.attr("height", function(d){
			return yScale(d);
		});
		//use .each("end", function(){d3.select(this).attr("fill", "red");})
		// to change something at the end of animation
}

$(document).ready(function(){

	//define size
	var windowWidth = window.innerWidth,
		windowHeight = window.innerHeight,
		canvasWidth = 0.5 * windowWidth, //this is the dimension of the entire d3 box
		canvasHeight = 0.3 * windowHeight,
		paddingTop = 30,
		paddingBottom = 30,
		paddingLeft = 30,
		paddingRight = 30,
		graphHeight = canvasHeight - paddingTop - paddingBottom, //this is the dimension of bargraph;
		graphWidth = canvasWidth - paddingLeft - paddingRight;

	var canvas = d3.select(".graph")
				.append("svg")
				.attr("height", canvasHeight)
				.attr("width", canvasWidth)
				.append("g")
				.attr("transform", "translate(" + paddingTop + ", " + paddingLeft + ")");

	//set up scale
	var yScale = d3.scale.linear()
						.domain([0, 100]) //google trends index goes up to 100
						.range([0, graphHeight]);

	var canvasData = {
		"canvas":canvas,
		"yScale":yScale,
		"graphHeight":graphHeight,
		"graphWidth":graphWidth
	};

	//fetch data
	var current_topic = window.current_topic;
	$.ajax({
	  url: 'trends/' + current_topic,
	  data: {topic: current_topic},
	  success: function(response){
	  	console.log(response);
	  }
	});

	var dataArray = [];
	for(var i = 0; i < 40; i++){
		dataArray[i] = Math.random()*100;
	};

	updateGraph(dataArray, canvasData);
});	

