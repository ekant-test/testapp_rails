//= require ./script/user

$(document).ready(function(){
  $(document).find('.jdelete-account').on('click', function(){
    $('#confirm').modal('show');
  });

  if($('.cart').length){
    $('.cart').click(function(){
      if($('.pushy').hasClass('pushy-left')){
        $('.pushy-left').attr('class','pushy pushy-open');
      }else{
        $('.pushy-open').attr('class','pushy pushy-left');
        $('body').removeClass('pushy-active');
      }
    });
  }
});