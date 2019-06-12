class @Search
  INDEX_CONTAINER = '.container_recordings'
  LANGUAGE_CONTAINER = '.jselect-language'
  INDEX_TEMPLATE = '#recordings-template'
  SELECT_LANGUAGE_TEMPLATE = '#languages-template'

  execute: (data)->
    $.ajax
      url: "/v1/recordings"
      type: 'GET'
      dataType: 'json'
      data: data
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          appendRecordings(response.data.results)
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false

  get_languages: ->
    $.ajax
      url: "/v1/languages?contains_all_languages=true"
      type: 'GET'
      dataType: 'json'
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          appendLanguages(response.data.languages)
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false

  rate_record: (rate_type, record_id)->
    $.ajax
      url: "/v1/recordings/" + record_id + "/rates"
      type: 'POST'
      dataType: 'json'
      data: {rate_type: rate_type}
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          $.notify response.message, 'success'
          window.setTimeout(location.reload(), 3000);
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false


  appendRecordings = (results) ->
    $(INDEX_CONTAINER).html('')
    template = _.template($(INDEX_TEMPLATE).html())
    _.each results, (recording, idx) ->
      $(INDEX_CONTAINER).append(template(recording))

  appendLanguages = (languages) ->
    template = _.template($(SELECT_LANGUAGE_TEMPLATE).html())
    $(LANGUAGE_CONTAINER).append(template({languages: languages}))

  # appendFormCreateUser: ->
  #   template = _.template($(FORM_CREATE_TEMPLATE).html())
  #   $('.jcontainerFormAddUser').append(template())

  actionDeleteUser = ->
    $(document).find('.jdelete-user').on 'click', ->
      user_id = $(this).data('id')
      cnf = confirm('Are you sure?')
      if cnf == true
        destroy user_id
      false