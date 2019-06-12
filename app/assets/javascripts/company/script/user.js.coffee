class @User
  INDEX_CONTAINER = '#jcompany-users'
  INDEX_TEMPLATE = '#company-users-template'
  FORM_CREATE_TEMPLATE = '#company-add-form-create-users-template'

  index: (data)->
    $.ajax
      url: "/v1/users"
      type: 'GET'
      dataType: 'json'
      data: data
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          appendUsers(response.data.users)
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false

  create_multiple_users: (data)->
    $.ajax
      url: Routes.create_multiple_users_v1_users_path()
      type: 'POST'
      dataType: 'json'
      data: {users: data}
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

  destroy = (user_id)->
    $.ajax
      url: Routes.v1_user_destroy_user_path(user_id)
      type: 'DELETE'
      dataType: 'json'
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          location.reload()
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false

  destroy_users: (user_ids)->
    $.ajax
      url: Routes.destroy_users_v1_users_path()
      type: 'DELETE'
      dataType: 'json'
      data: user_ids
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          location.reload()
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false

  appendUsers = (users) ->
    $(INDEX_CONTAINER).html('')
    $('.jtab-company-users').addClass('active')
    template = _.template($(INDEX_TEMPLATE).html())
    _.each users, (user, idx) ->
      user.idx = idx + 1
      $(INDEX_CONTAINER).append(template(user))
    actionDeleteUser()

  appendFormCreateUser: ->
    template = _.template($(FORM_CREATE_TEMPLATE).html())
    $('.jcontainerFormAddUser').append(template())

  actionDeleteUser = ->
    $(document).find('.jdelete-user').on 'click', ->
      user_id = $(this).data('id')
      cnf = confirm('Are you sure?')
      if cnf == true
        destroy user_id
      false