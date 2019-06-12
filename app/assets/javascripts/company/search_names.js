//= require ./script/search

$(document).ready(function(){
  var search = new Search();
  search.get_languages();
  // var data = {};
  // data.name = $('#jsearch-recordings').find('#name').val();
  // data.language = $('#jsearch-recordings').find('.jselect-language').val();
  // data.record_type = $('#jsearch-recordings').find('#record_type').val();
  // var search = new Search();
  // search.execute(data);

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

  $(document).on('click', '#clear-text', function(){
    $(document).find('#name').val('');
    var data = {};
    data.language = $('#jsearch-recordings').find('.jselect-language').val();
    data.record_type = $('#jsearch-recordings').find('#record_type').val();
    var search = new Search();
    search.execute(data);
  });

  $(document).on('click', '#search-action', function(){
    var data = {};
    data.name = $('#jsearch-recordings').find('#name').val();
    data.language = $('#jsearch-recordings').find('.jselect-language').val();
    data.record_type = $('#jsearch-recordings').find('#record_type').val();
    var search = new Search();
    search.execute(data);
  });

  $(document).find('#name').bind("enterKey",function(e){
    var data = {};
    data.name = $('#jsearch-recordings').find('#name').val();
    data.language = $('#jsearch-recordings').find('.jselect-language').val();
    data.record_type = $('#jsearch-recordings').find('#record_type').val();
    data.action_type = 'autocomplete'
    var search = new Search();
    search.execute(data);
    return false;
  });

  $(document).find('#name').keyup(function(e){
    if(e.keyCode == 13)
    {
      $(this).trigger("enterKey");
    }
  });

  $(document).on('click', ".upvote", function(){
    var search = new Search();
    search.rate_record("upvote", $(this).data('id'));
  })

  $(document).on('click', ".report", function(){
    var search = new Search();
    search.rate_record("report", $(this).data('id'));
  })

  $(document).on('click', ".glyphicon-volume-down", function(){
    $('#audio-area').html('')
    var url = $(this).data('audio')
    $('#audio-area').html('<audio controls autoplay id="audio_element" style="visibility: hidden;"><source src="' + url + '"></audio>');
    // audio.play();
  })

  $('.jsearch_tab').on('click', function(){
    id = $(this).attr('id')
    if (id == 'search-name'){
      $(document).find('#record_type').val('name');
    }else{
      $(document).find('#record_type').val('user');
    }
    var data = {};
    data.language = $('#jsearch-recordings').find('.jselect-language').val();
    data.record_type = $('#jsearch-recordings').find('#record_type').val();
    var search = new Search();
    search.execute(data);
  })
});