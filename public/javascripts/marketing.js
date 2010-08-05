
$(document).ready(function(){
  email = $('#user_session_email');
  password = $('#user_session_password');
  bind_account_form_switch(email);
  bind_account_form_switch(password);
  
  $('#account-button.logged-out').click(function(){
    $(this).toggleClass('active');
    $('#account-form').slideToggle('fast');
    
    return false;
  });

  $('#account-button.logged-in').click(function(){
     $(this).toggleClass('active');
     $('#account-links').slideToggle('fast');

     return false;
   });
});

function bind_account_form_switch(object){
  
  if(object.val() == '' ){
    object.addClass('empty');
  }
  
  object.focus(function(){
    object.removeClass('empty');
  });
  
  object.blur(function(){
    if( object.attr('value') == "" ){
      object.addClass('empty');
    }
  });
}