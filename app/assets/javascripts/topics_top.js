$(document).ready(function(){

	$(".topic").on("click", function(){
		$(".topic").removeClass( "highlighted" );
		$(this).addClass( "highlighted" );
	});

	//$('span:contains('+topic+')').closest(".topic").addClass( "highlighted");
});
