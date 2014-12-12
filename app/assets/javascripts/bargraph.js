function updateGraph(dateArray, trendsArray){
	// set up the date data
	var minDate = new Date(dateArray[0]),
		maxDate = new Date(dateArray[1]);

	//set up scale
	var xScale = d3.time.scale()
	        	.domain([minDate, maxDate])
				.range([0, graphWidth]),
		yScale = d3.scale.linear()
				.domain([0, 100]) //google trends index goes up to 100
				.range([graphHeight, 0]);

	updateBars(trendsArray, yScale);
	updateAxis(xScale, yScale);
}

function updateBars(trendsArray, yScale){
	canvas.selectAll("rect").remove(); //lol... force reset

	var dataNSize = trendsArray.length,
		barSize = graphWidth / dataNSize;
	var colorScale = d3.scale.linear()
							.domain([0, 100])
							.range(["#FFFF66", "#FF0000"]);
	
	var bars = canvas.selectAll("rect")
					.data(trendsArray)
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
	$(".graph").find(".axis").remove(); //lol... force reset
	$(".graph").find(".y-label").remove(); //lol... force reset

	var xAxis = d3.svg.axis()
			.orient("bottom")
			.outerTickSize([2])
			.scale(xScale),
		yAxis = d3.svg.axis()
			.orient("left")
			.scale(yScale)
			.outerTickSize([2])
			.ticks(1);

	d3.select(".graph svg")
		.append("g")
		.attr("class", "axis")
		.attr("transform", "translate(" + paddingLeft + ", " + (graphHeight + paddingTop) + ")")
		.call(xAxis);
	d3.select(".graph svg")
		.append("g")
		.attr("class", "axis")
		.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
		.call(yAxis);

	//add the yAxis title
	d3.select(".graph svg").append("text")
	    .attr("class", "y-label")
	    .attr("text-anchor", "end")
	    .attr("y", paddingLeft*0.7)	//this is actually the horizontal distance from the left
	    .attr("x", -(graphHeight*0.3)) //this is actually the vertical distance from the top
	    .attr("transform", "rotate(-90)")
	    .text("Search Popularity");
}

function parseTopicToURL(topic_string){
	return topic_string.replace(" ", "-");
}

$(document).ready(function(){
	//define canvas size, a bunch of fucking globals, what!
	canvasWidth = $(".content").width(), //this is the dimension of the entire d3 box
	canvasHeight = 300,
	paddingTop = 10,
	paddingBottom = 30,
	paddingLeft = 50,
	paddingRight = 0,
	graphHeight = canvasHeight - paddingTop - paddingBottom, //this is the dimension of bargraph;
	graphWidth = canvasWidth - paddingLeft - paddingRight;

	canvas = d3.select(".graph")
			.append("svg")
			.attr("height", canvasHeight)
			.attr("width", canvasWidth)
			.append("g")
			.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
			.attr("height", graphHeight)
			.attr("width", graphWidth);

	//fetch data
	var dbtopic = gon.current_topic;
	var current_topic = dbtopic.title;
	$.ajax({
	  url: 'trends/',
	  data: {topic: parseTopicToURL(current_topic)},
	  success: function(response){
	  	updateGraph(response.dates, response.trends);
	  }
	});

	//when clicking on a topic
	$(".topic-title").on("click", function(){
		var current_topic = $(this).find("h3").html().trim();
		topicClick(current_topic);
	});
});	

function updateArticles(response){
	$(".articles-body").html(response);
}

function topicClick(current_topic){
	$.ajax({
	  	url: 'trends/',
	  	data: {topic: parseTopicToURL(current_topic)},
	  	success: function(response){
	  		updateGraph(response.dates, response.trends);
	  	}
	});
	$.ajax({
		url: 'articles/',
		data: {topic: parseTopicToURL(current_topic)},
		success: function(response){
			updateArticles(response);
		}
	});
}