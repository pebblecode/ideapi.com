jQuery(document).ready(function(){
  
  $('a.button').each(function () {
    $(this).prepend('<span class="btn_left">');
    $(this).append('<span class="btn_right">');
  });
	
	// BRIEF CREATION SECTION
	
  // $('.brief_section .brief_section_title h3').click(function() {
  //  $(this).parent().next().slideToggle('fade', function (){
  //    $(this).find('.brief_answer textarea:first').focus();
  //  });
  //  return false;
  // }).parent().next().hide();
  // 
  // var current_location = document.location.toString();
  //   if (current_location.match('#section')) { 
  //     $('#' + current_location.split('#')[1] + ' .brief_section_title').click();
  //   } else {
  //     $('.brief_section:first .brief_section_title').next().toggle();
  //   }
  // 
  // $('.brief_question_help').hide();
  // 
  // $('.brief_answer textarea').focus(function () {
  //   $(this).parent().siblings('.brief_question').find('.brief_question_help').fadeIn();
  // });
  // 
  //   $('.brief_answer textarea').blur(function () {
  //   $(this).parent().siblings('.brief_question').find('.brief_question_help').fadeOut();
  //   });
  //   
  //   $('.optional_brief_question').hide();
  //   
  //   $('.brief_section_brief_question').each(function() {
  //     if (!$(this).hasClass('optional_brief_question') && $(this).next().hasClass('optional_brief_question')) {
  //       $(this).append("<a href='#' class='button show_question_details'>Add detail</a>");
  //     };
  //   });
  //   
  //   $('.brief_section_brief_question a.show_question_details').click(function(){
  //     $(this).hide();
  //     
  //     var hidden = $(this).parent().nextAll('.brief_section_brief_question');
  //     
  //     for (var i=0; i < hidden.length; i++) {
  //       $(hidden[i]).fadeIn();
  //       if (!$(hidden[i+1]).hasClass('optional_brief_question')) { break };
  //     };
  //         
  //     return false;
  //   });
  
  // // END BRIEF CREATION SECTION
  //    
  // // for the back end.
  // $("select[multiple]").asmSelect({
  //   animate: true
  // });


  // // COMMENTS
  // 
  // $("a.reply_to_comment").click(function (){
  //   $(this).nextAll('div.inline_form_comment').fadeIn();
  //   $(this).fadeOut();
  //   return false;
  // }).show().nextAll('div.inline_form_comment').hide();
  // 
  // jQuery('.inline_form_comment textarea').blur(function () {
  //   if (!jQuery(this).parents('.inline_form_comment').hasClass('active') && $(this).attr("value") == "") {
  //     jQuery(this).parents('.inline_form_comment').fadeOut();
  //     jQuery(this).parents('.inline_form_comment').prevAll('a.reply_to_comment').fadeIn();
  //   }
  // });
  // 
  // jQuery('.inline_form_comment').hover(
  //   function(){ 
  //     jQuery(this).addClass("active");
  //   },
  //   function(){
  //     jQuery(this).removeClass("active"); 
  //   }
  // );
  	
});

