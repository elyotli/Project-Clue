function raise_up(jquery) {
		$("#topic_list").on("click",".topic", function(){
		
			$(".topic").removeClass( "highlighted" );
			$(this).addClass( "highlighted" );

	});
	};
//works?

$(document).ready(raise_up);
$(document).on("page:load", raise_up);