$(document).ready(function(){
  jQuery.update_collaborators();
  jQuery.ajaxify_comments();
  jQuery.ajaxify_questions_and_answers();
  jQuery.ajaxify_item_revisions();
  
  jQuery('.question').each(function () {
    $(this).setup_answer_form();
  });
  jQuery.user_links_external();
  
  jQuery('body#documents.show').inline_edit_documents();
  $('.toggle-page-help').live('click', function(){
    var _span = $(this).find('span');
    if(_span.text() == 'help'){
      _span.text('close help');
    }else{
      _span.text('help');
    }
    
    $(this).toggleClass('selected');
    $('#page-help').toggle('blind', {}, 500);
  });
  
  $('.collaborator_search input').focus(function(){
    $(this).parent().toggleClass('active');
  }).blur(function(){
    $(this).parent().toggleClass('active');
  });
  
});
