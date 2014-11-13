$(document).ready(function(){

	$(".topic").on("click", function(){
		$(".topic").removeClass( "highlighted" );
		$(this).addClass( "highlighted" );
	});
	var x = document.cookie
	alert(x)
	//$('span:contains('+topic+')').closest(".topic").addClass( "highlighted");
});