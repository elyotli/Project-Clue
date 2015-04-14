$(document).ready(function(){
	//define canvas size, a bunch of globals, should change to closure
	canvasWidth 	= $(".graph-container").width(),
	canvasHeight 	= 300,
	paddingTop 		= 10,
	paddingBottom 	= 30,
	paddingLeft 	= 50,
	paddingRight 	= 0,
	graphHeight 	= canvasHeight-paddingTop-paddingBottom,
	graphWidth 		= canvasWidth-paddingLeft-paddingRight;

	canvas = d3.select(".graph-container")
			.append("svg")
			.attr("height", canvasHeight)
			.attr("width", canvasWidth)
			.attr("id", "graph-canvas")
			.append("g")
			.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
			.attr("height", graphHeight)
			.attr("width", graphWidth);

});

function updateGraph(response){
	var labels 	= [];
	var values 	= [];
	for(var i = 0; i<response.length; i++){
		labels.push(new Date(response[i].date));
		values.push(response[i].index);
	}

	//set up scale
	var xScale = d3.time.scale()
	        	.domain([labels[0], labels[labels.length-1]])
				.range([0, graphWidth]),
		yScale = d3.scale.linear()
				.domain([0, 100])
				.range([graphHeight, 0]);

	resetGraph();
	updateBars(values, yScale);
	updateAxis(xScale, yScale);
}

function resetGraph(){
	canvas.selectAll("rect").remove();
	$(".graph-container").find(".axis").remove();
	$(".graph-container").find(".y-label").remove();
}

function updateBars(values, yScale){
	var dataNSize = values.length,
		barSize = graphWidth / dataNSize;
	var colorScale = d3.scale.linear()
						.domain([0, 100])
						.range(["#FFFF66", "#FF0000"]);
	
	var bars = canvas.selectAll("rect")
					.data(values)
					.enter()
						.append("rect")
						.attr("width", barSize)
						.attr("height", 0) 
						.attr("fill", function(d){
							return colorScale(d);
						})
						.attr("y", function(d, i){
							return graphHeight;//starting from top down, so graphHeight is all the way at the bottom
						})
						.attr("x", function(d, i){
							return barSize * i;
						});

	bars.transition()
		.duration(300)
		.attr("y", function(d){
			return yScale(d);
		})
		.attr("height", function(d){
			return graphHeight - yScale(d);
		});
}

function updateAxis(xScale, yScale){
	var xAxis = d3.svg.axis()
			.orient("bottom")
			.outerTickSize([2])
			.scale(xScale),
		yAxis = d3.svg.axis()
			.orient("left")
			.scale(yScale)
			.outerTickSize([2])
			.ticks(1);

	d3.select("#graph-canvas")
		.append("g")
		.attr("class", "axis")
		.attr("transform", "translate(" + paddingLeft + ", " + (graphHeight + paddingTop) + ")")
		.call(xAxis);
	d3.select("#graph-canvas")
		.append("g")
		.attr("class", "axis")
		.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
		.call(yAxis);

	//add the yAxis title
	d3.select("#graph-canvas").append("text")
	    .attr("class", "y-label")
	    .attr("text-anchor", "end")
	    .attr("y", paddingLeft*0.7)	//this is actually the horizontal distance from the left
	    .attr("x", -(graphHeight*0.3)) //this is actually the vertical distance from the top
	    .attr("transform", "rotate(-90)")
	    .text("Google Search Popularity");
}