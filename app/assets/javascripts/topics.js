// Onload
function updateHeights() {
	var maxHeight = 0;
	var testHeight = 0;

	$('.article').each(function(i,a) {
		testHeight = $(a).height() + $(a).find('.source').height();

		if(testHeight > maxHeight) {
			maxHeight = testHeight;
		}

		$('.article').height(maxHeight);
	});
}

$(document).ready(function(){
	updateHeights();
});

// click on stats toggle (twitter, etc.)
$(document).on('click', '.buttons', function(e) {
	var id = $(e.target).attr('id');
	if (id != currentStatistic) {
		currentStatistic = id;
		dataset = partialDataset();
		populateGraph();
	}
});

function updateArticalPagination() {
	var page = parseInt($('.article').first().data('current-page'),10);
	var totalArticles = parseInt($('.article').first().data('total-articles'),10);
	articlePageTotal = parseInt($('.article').first().data('total-pages'),10);

	var minRange = page * 4 - 3;
	var maxRange = page * 4;
	maxRange = maxRange > totalArticles ? totalArticles : maxRange;

	var text = minRange + '-' + maxRange;

	$('#article-page-current').text(text);
	$('#article-page-total').text(totalArticles);
}

// click on article carousel buttons
$(document).on('click', '#articles .fa', function(e) {
	var articlePageTarget = 0;
	var bottomLimit = 0;

	var articlesSet = $('#articles-set');
	if(articlesSet.length != 0) {
		var articlesData = articlesSet.data();
		articlePageTotal = articlesData.totalPages;
		if($(e.target).hasClass('fa-chevron-left')) {
			articlePageTarget = articlesData.page - 1;
			bottomLimit = -1;
		}
		else {
			articlePageTarget = articlesData.page + 1;
			articlePageTotal = articlesData.totalPages - 1;
		}
	}
	else {
		// dayId = maxDayId;
		if($(e.target).hasClass('fa-chevron-left')) {
			articlePageTarget = articlePage - 1;
		}
		else {
			articlePageTarget = articlePage + 1;
		}
	}
	if(articlePageTarget > bottomLimit && articlePageTarget <= articlePageTotal) {
		var url = '';
		var data = '';
		var type = '';

		if(articlesSet.length != 0) {
			data = 'articles_set=' + JSON.stringify(articlesData.articlesSet) +
							'&page=' + articlePageTarget;
			type = 'post';
			url = "topics/1/date_range";
		}
		else {
			data = '';
			type = 'get';
			url = 'topics/' + topicId + '/date/' + dayId + '/articles/' + articlePageTarget;
			console.log(url);
		}

		$.ajax({
			url: url,
			type: type,
			dataType: 'html',
			data: data,
			success: function(response) {
				articlePage = articlePageTarget;
				$('#article_list').html(response);
				updateArticalPagination();
				updateHeights();
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
			currentStatistic = 'google_trend_index';
			dataset = partialDataset();
			populateGraph();

			//update articles

			var articlePageTarget = 1;
			console.log(maxDayId);
			dayId = parseInt(maxDayId,10);
			$.ajax({
				url: 'topics/' + topicId + '/date/' + maxDayId + '/articles/' + articlePageTarget,
				type: 'get',
				dataType: 'html',
				success: function(response) {
					articlePage = articlePageTarget;
					$('#article_list').html(response);
					updateArticalPagination();
					updateHeights();
					articlePageTotal = parseInt($('.article').first().data('total-pages'),10);
					console.log(articlePageTotal);
				}
			});
		}
	});
});

// click on topic carousel buttons
$(document).on('click', '#topics .fa', function(e) {
	var currentDateStr = $('#date').find('span').text();
	var year = currentDateStr.substr(0,4);
	var month = currentDateStr.substr(5,2) - 1;
	var day = currentDateStr.substr(8,2);
	var currentDateMilliSeconds = new Date(year, month, day).valueOf();
	var dayInMilliSeconds = 60*60*24*1000;
	var targetDateMilliSeconds = 0;
	var targetDateStr = '';

	if($(e.target).hasClass('fa-chevron-left')) {
		targetDateMilliSeconds = currentDateMilliSeconds - dayInMilliSeconds;
	}
	else {
		targetDateMilliSeconds = currentDateMilliSeconds + dayInMilliSeconds;
	}
	targetDateStr = new Date(targetDateMilliSeconds).toISOString().replace(/T.*/i,'');
	console.log(targetDateStr + ' '+minDate+' '+maxDate);
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
				currentStatistic = 'google_trend_index';
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
				articlePageTotal = $('.article').first().data('total-pages');
				$('#date').find('span').text($('.topic').first().data('day-string'));
				window.clearInterval(responseChecker);
				updateArticalPagination();
				updateHeights();
			}
		}, 100);
	}
});
