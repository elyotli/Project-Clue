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

// click on topic carousel buttons
$(document).on('click', '#topics .btn', function(e) {
	var currentDateStr = $('#date').text().replace(/-/g,'');
	var year = currentDateStr.substr(0,4);
	var month = currentDateStr.substr(4,2) - 1;
	var day = currentDateStr.substr(6);
	var currentDateMilliSeconds = new Date(year, month, day).valueOf();
	var dayInMilliSeconds = 60*60*24*1000;
	var targetDateMilliSeconds = 0;
	var targetDateStr = '';

	if($(e.target).hasClass('btn_l')) {
		targetDateMilliSeconds = currentDateMilliSeconds - dayInMilliSeconds;
	}
	else {
		targetDateMilliSeconds = currentDateMilliSeconds + dayInMilliSeconds;
	}
	targetDateStr = new Date(targetDateMilliSeconds).toISOString().replace(/T.*/i,'');
	if(targetDateStr >= minDate && targetDateStr <= maxDate) {
		var articlesURL = 'days/'+targetDateStr+'/articles';
		var statisticsURL = 'days/'+targetDateStr+'/popularity';
		var topicsURL = 'days/'+targetDateStr+'/topics';
		var responseCounter = 0;

		$.ajax({
			url: 'days/' + targetDateStr + '/topics',
			type: 'get',
			dataType: 'html',
			success: function(response) {
				$('#topic_list').html(response);
				responseCounter++;
			}
		});

		$.ajax({
			url: 'days/' + targetDateStr + '/articles',
			type: 'get',
			dataType: 'html',
			success: function(response) {
				$('#article_list').html(response);
				responseCounter++;
			}
		});

		$.ajax({
			url: 'days/' + targetDateStr + '/popularity',
			type: 'get',
			dataType: 'json',
			success: function(response) {
				currentStatistic = 'twitter_popularity';
				fullDataset = response;
				dataset = partialDataset();
				populateGraph();
				responseCounter++;
			}
		});

		var responseChecker=setInterval(function () {
			if(responseCounter == 3) {
				topicId = $('.topic').first().data('id');
				dayId = $('.topic').first().data('day-id');
				articlePage = 1;
				articlePageTotal = $('.article').first().data('total-articles');
				$('#date').text($('.topic').first().data('day-string'));
				window.clearInterval(responseChecker);
			}
		}, 100);
	}
});
