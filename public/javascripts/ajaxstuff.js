function ajax_submit(form, success, error){
  $.ajax({
    type: 'POST',
    url: form.attr('action'),
    data: form.serialize(),
    complete: function(){
    },
    error: function(response){
      error(response);
    },
    success: function(response){
      success(response);
    },
    cache: false
  });
}


$(document).ready(function(){
  
  /* 
    Collaboration form 
    
    collab_ation links formerly fired a collab_action. Now they simply submit the form they're located in.
    On success, the 'success' function is called via the $.ajax({success}) callback. When an error occurrs, 
    the user is notified via an alert box (maybe change this) and asked to reload. 
    
    There are two possible error cases I've encountered:
      a)  if a user was removed from the brief by another author
          and we try to remove it again, recordnotfound exception 
          is triggered, returning a 500 error.
      b)  if a user removes the author role from their collaboration
          user, and before the widget is reloaded, tries to apply a
          role to another user.
    On both cases, they'll be asked to reload the page, which will solve the problem by updating the widget options.
  */
  var success = function(data){
    $('#update_collaborators').fadeOut().html(data).fadeIn();
    $.setup_collaboration_widget();
  };
  var error = function(data){ alert('The server responded with an error. Please reload and try again.');};
  
  $('#briefs ul.add_collaborators form.new_user_brief').live('submit', function(){
    // replace ADD button with spinner
    $(this).find('.add_user_brief_button').hide().spin(false, 'ui/loading');

    ajax_submit($(this), success, error);    
    return false;
  });
  
  
  $('#update_collaborators ul.options a.collab_action').live('click', function(){
    var _link = $(this);
    var _form = $(this).parents('form');
    _link.hide().spin(false, 'ui/loading');
    ajax_submit(_form, success, error);
    return false;
  });
  
  
    // 
    // jQuery.fn.update_collab_link = function () {
    // 
    //   jQuery(this).parents('ul').find('li input:checkbox, li input:radio').each(function () {        
    //     jQuery(this).next('a').toggleClass( "selected", jQuery(this).attr('checked') );
    //   });
    // 
    //   return jQuery(this);
    // 
    // };
    // 
});
