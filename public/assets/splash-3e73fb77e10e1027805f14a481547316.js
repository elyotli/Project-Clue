$(document).ready(function(){$(".td").hover(function(){$(this).find(".topic_heading").hide(),$(this).find(".images").css("opacity","1")},function(){$(this).find(".topic_heading").show(),$(this).find(".images").css("opacity","0.8")})}),$(".td").on("click",function(){var i=$(this).find("span").text();document.cookie="active="+i});