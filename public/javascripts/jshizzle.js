jQuery(document).ready(function(){
	
	$('.section h3').click(function() {
		$(this).next().slideToggle('fade', function (){
		  $(this).find('.answer textarea:first').focus();
		});
		return false;
	}).next().hide();
	
	var current_location = document.location.toString();
  if (current_location.match('#section')) { 
    $('#' + current_location.split('#')[1] + ' h3').click();
  } else {
    $('.section:first h3').next().toggle();
  }
	
	
	$('.question_help').hide();
	
	$('.answer textarea').focus(function () {
	  $(this).parent().siblings('.question').find('.question_help').fadeIn();
	});

  $('.answer textarea').blur(function () {
	  $(this).parent().siblings('.question').find('.question_help').fadeOut();
  });
  
	
});

