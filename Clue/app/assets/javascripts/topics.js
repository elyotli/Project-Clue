// Onload

// click on stats toggle (twitter, etc.)
$(document).on('click', '.buttons', function(e) {
	var id = $(e.target).attr('id');
	if (id != currentStatistic) {
		currentStatistic = id;
		dataset = partialDataset();
		populateGraph();
	}
});


// click on article carousel buttons
$(document).on('click', '#articles .btn', function(e) {
	var articlePageTarget = 0;
	if($(e.target).hasClass('btn_l')) {
		articlePageTarget = articlePage - 1;
	}
	else {
		articlePageTarget = articlePage + 1;
	}
	if(articlePageTarget > 0 && articlePageTarget <= articlePageTotal) {
		$.ajax({
			url: 'topics/' + topicId + '/date/' + dayId + '/articles/' + articlePageTarget,
			type: 'get',
			dataType: 'html',
			success: function(response) {
				articlePage = articlePageTarget;
				$('#article_list').html(response);
			}
		});
	}
});

// click on topic
$(document).on('click', '.topic', function(e){
	var id = $(e.target).closest('.topic').data('id');
	topicId = id;
	var url = 'topics/'+id+'/statistics/popularity';
	$.ajax({
		url: url,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			//update graph
			fullDataset=response;
			currentStatistic = 'twitter_popularity';
			dataset = partialDataset();
			populateGraph();

			//update articles

			var articlePageTarget = 1;
			$.ajax({
				url: 'topics/' + topicId + '/date/' + dayId + '/articles/' + articlePageTarget,
				type: 'get',
				dataType: 'html',
				success: function(response) {
					articlePage = articlePageTarget;
					$('#article_list').html(response);
				}
			});
		}
	});
});
