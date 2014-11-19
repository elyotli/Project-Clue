$(document).ready(function(){

	$("#topic_list").on("click",".topic", function(){
		$(".topic").removeClass( "highlighted" );
		$(this).addClass( "highlighted" );
	});

	//$('span:contains('+topic+')').closest(".topic").addClass( "highlighted");
});
