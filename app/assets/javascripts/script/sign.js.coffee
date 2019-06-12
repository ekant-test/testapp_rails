class @Sign
  login: ->
    form = $("#jlogin-form")
    email = form.find("#jemail").val()
    password = form.find("#jpassword").val()
    $.ajax
      url: Routes.v1_sign_in_path()
      type: 'POST'
      dataType: 'json'
      data: { email: email, password: password, is_web: true }
      success: (res) ->
        if res.code == 200
          $.cookie("api_token", res.data.api_token)
          window.location.replace(Routes.company_users_path())
        else
          $.notify res.message
      error: (res) ->
        $.notify res

  logout: ->
    $.ajax
      url: Routes.v1_sign_out_path()
      type: 'DELETE'
      dataType: 'json'
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (res) ->
        if res.code == 200
          window.location.replace(Routes.root_path())
        else
          $.notify res.message
      error: (res) ->
        $.notify res


  register: (data)->
    $.ajax
      url: Routes.v1_sign_up_path()
      type: 'POST'
      data: data
      dataType: 'json'
      success: (res) ->
        if res.code == 200
          window.location.replace(Routes.verify_emails_path())
        else
          $.notify res.message
        return
      error: (res) ->
        $.notify res

  forgot_password: ->
    $.ajax
      url: Routes.v1_forgot_password_path()
      type: 'POST'
      dataType: 'json'
      data: $("#forgot-password-form").serialize()
      headers: { 'Api-Token': $.cookie("api_token") }
      success: (response) ->
        if response.code == 200
          $('#login').find('#forgot-password').removeClass('active')
          $('#login').find('#forgot-password-sent').addClass('active')
          $.notify response.message, 'success'
        else
          $.notify response.message
      error: (res) ->
        $.notify res
    false
