$('#contactForm input.form-control, textarea').val('');
$('#success').css('display', 'block').addClass('animated bounceIn');

setTimeout(function(){
	$('#success').addClass('bounceOut');
	$('#success').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
		$(this).css('display', 'none');
	});

}, 3000);