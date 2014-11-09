// Onload

function parseDateToNumber(date) {
	return date.replace('-',',');
}

function parseDateToString(date) {
	return date.toJSON().replace(/T.*/i,'');
}

var date = '2014-04-04';
date = Date.parse(parseDateToNumber(date));
var dayInMilliSeconds = 24*60*60*1000;

// App

$(document).on('click', '#topics .btn_l', function(){
	var targetDate = date - dayInMilliSeconds;
	
});

$(document).on('click', '#topics .btn_r', function(){

});

$(document).on('click', '.topic', function(){

});

$(document).on('click', '#twitter', function() {

});

$(document).on('click', '#facebook', function() {

});

$(document).on('click', '#articles .btn_l', function() {

});

$(document).on('click', '#articles .btn_r', function() {

});

// D3 - Chart

// function Graph() {
// 	this.margin = {top: 20, right: 30, bottom: 30, left: 50};
// 	this.width = 865 - this.margin.left - this.margin.right;
// 	this.height = 288 - this.margin.top - this.margin.bottom;

// 	this.xScale = d3.time.scale()
// 		.range([0, this.width]);

// 	this.yScale = d3.scale.linear()
// 		.range([this.height, 0]);

// 	this.xAxis = d3.svg.axis()
// 		.scale(this.xScale)
// 		.orient('bottom');

// 	this.yAxis = d3.svg.axis()
// 		.scale(this.yScale)
// 		.orient('left');

// 	this.area = d3.svg.area()
// 		.x(function(d) { return this.xScale(d.date); })
// 		.y0(this.height)
// 		.y1(function(d) { return this.yScale(d.close); });

// 	this.svg = d3.select("#chart").append("svg")
// 			.attr("width", this.width + this.margin.left + this.margin.right)
// 			.attr("height", this.height + this.margin.top + this.margin.bottom)
// 		.append("g")
// 			.attr("transform", "translate(" + this.margin.left + "," + this.margin.top + ")");
// }

// Graph.prototype.parseDate = function(date) {
// 	return d3.time.format("%d-%b-%y").parse(date);
// };

// Graph.prototype.populateGraph = function() {
// 	var t = this;

// 	this.xScale.domain(d3.extent(t.dataset, function(d) { return d.date; }));
// 	this.yScale.domain(d3.extent(t.dataset, function(d) { return d.close; }));

// 	this.svg.append("path")
// 		.datum(t.dataset)
// 		.attr("class", "area")
// 		.attr("d", t.area);

// 	this.svg.append("g")
// 		.attr("class", "x axis")
// 		.attr("transform", "translate(0," + t.height + ")")
// 		.call(t.xAxis);

// 	this.svg.append("g")
// 		.attr("class", "y axis")
// 		.call(t.yAxis)
// 		.append("text")
// 		.attr("transform", "rotate(-90)")
// 		.attr("y", 6)
// 		.attr("dy", ".71em")
// 		.style("text-anchor", "end")
// 		.text("Tweets");
// };

// Graph.prototype.loadCSV = function(path) {
// 	var t = this;

// 	d3.csv(path,function(data){
// 		var dataset = [];

// 		data.forEach(function(d){
// 			dataset.push({date: t.parseDate(d.Date), close: +d.Close});
// 		});
		
// 		t.dataset = dataset;
// 		t.populateGraph();
// 	});
// };

// var graph = new Graph();
// graph.loadCSV('data/goog.csv');


var margin = {top: 20, right: 30, bottom: 30, left: 50},
    width = 865 - margin.left - margin.right,
    height = 288 - margin.top - margin.bottom;

var xScale = d3.time.scale()
	.range([0, width]);

var yScale = d3.scale.linear()
	.range([height, 0]);

var xAxis = d3.svg.axis()
	.scale(xScale)
	.orient('bottom');

var yAxis = d3.svg.axis()
	.scale(yScale)
	.orient('left');

var area = d3.svg.area()
	.x(function(d) { return xScale(d.date); })
	.y0(height)
	.y1(function(d) { return yScale(d.close); });

var svg = d3.select("#chart").append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
	.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var dataset = [];
var parseDate = d3.time.format("%d-%b-%y").parse;

d3.csv('data/goog.csv',function(data){
	data.forEach(function(d){
		dataset.push({date: parseDate(d.Date), close: +d.Close});
	});

	xScale.domain(d3.extent(dataset, function(d) { return d.date; }));
	yScale.domain(d3.extent(dataset, function(d) { return d.close; }));

	svg.append("path")
		.datum(dataset)
		.attr("class", "area")
		.attr("d", area);

	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + height + ")")
		.call(xAxis);

	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis)
		.append("text")
		.attr("transform", "rotate(-90)")
		.attr("y", 6)
		.attr("dy", ".71em")
		.style("text-anchor", "end")
		.text("Tweets");

});


