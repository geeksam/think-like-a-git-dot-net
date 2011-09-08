jQuery.fn.rdy = function(func) {
	this.length && func.apply(this);
	return this;
};

jQuery.fn.placeHolder = function(default_value) {
	var el = jQuery(this);
	default_value = default_value || el.attr('placeholder');
	
	if(default_value && default_value.length) {
		el.focus(function() {
			if(el.val() == el.data('default_value')) el.val('').removeClass('empty');
		});

		el.blur(function() {
			if(!el.val().length) el.val(el.data('default_value')).addClass('empty');
		});

		el.closest('form').submit(function() {
			if(el.val() == el.data('default_value')) el.val('');
		});

		el.data('default_value', default_value).attr('title', default_value).trigger('blur');
	}
	
	return this;
};

jQuery(function($) {


	if($.browser.msie) {
		$('body').addClass('is-ie');
		if($.browser.version == 7) $('body').addClass('is-ie7');
		if($.browser.version == 8) $('body').addClass('is-ie8');
	}

	$('.search-input').placeHolder();
	$('.widget-enews #email-address').placeHolder();

	//slider
	$('#slider').rdy(function() {

		$('#slider .a-project:nth-child(4n)').addClass('last');
		var current = 0, length = Math.ceil($('#slider .article').length / 4);

		$('#slider .prev, #slider .next').click(function() {
			var i = $(this).attr('class').indexOf('next') != -1 ? 1 : -1;
			current += i;
			if(current < 0) current = length - 1;
			if(current > length - 1) current = 0;
			$('#slider-inner').animate({ left: -978 * current });
			return false;
		});
	});


	//tooltips
	$(".w-tooltip").tipTip({ delay: 10 });


	// Initialize javascript tabs for toggling
	$("ul.tabs").tabs("div.pane", {
		effect: 'fade'
	});
	$("ul.comment-controls").tabs("ol.commentlist", {
		effect: 'fade'
	});


	// Initialize hover over dropdown navigation menus
	$("#nav-top > .wrapper ul, #main-menu > .wrapper ul").superfish({
		delay:			200,
		speed:			'fast',
		autoArrows:		false
	});
	$('#nav-top ul li:first').addClass('first');


	//css
	$('.post-related .article:odd').addClass('last');
	$("#main-nav ul.nav li:last-child").addClass("last");
	$("#slider .post:nth-child(4)").addClass("last");
	$("#content div.one_third:nth-child(3n+0), #content div.one_fourth:nth-child(4n+0)").addClass("last");
	$('.page-template-template-sidebar-left-php #sidebar').addClass('first');
	$('#sidebar .widget:last, #subfooter .widget:last, #subfooter .widget:nth-child(3n+0)').addClass("last");
	$('.widget-ads .ad-square:odd, .widget-ads .ad-square:nth-child(2n)').addClass("last");
	$('#main-menu ul li:last').addClass("last");

});