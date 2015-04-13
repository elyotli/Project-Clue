$(document).ready(function(){
	$('#search-button').on('click', function(event){
		event.preventDefault();
		$.ajax({
			type	:"GET",
			url		:"/trends", 
			datatype:"json",
			data    : {
				topic: $('#search-text').val()
			},
			success :function(response){
				console.log(response);
				updateGraph(response);
			},
			error	:function(response){
				console.log(response);
			}
		})
	});



});