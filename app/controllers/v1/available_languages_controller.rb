class V1::AvailableLanguagesController < V1::BaseController

  api :GET, '/available_languages?language=English', "Get list languages"
  example '
  {
  "code": 200,
  "message": "Get successfully!",
  "data": {
      "intro": {
        "intro_dropdown": "Choose App Language"
      },
      "main": {
        "main_loginWithGG": "LOGIN WITH GOOGLE+",
        "main_loginWithLinked": "LOGIN WITH LINKEDIN",
        "main_loginWithFB": "LOGIN WITH FACEBOOK",
        "main_register": "REGISTER",
        "main_login": "LOGIN",
        "main_forgotten": "FORGOTTEN LOGIN DETAILS?"
      },
      "register": {
        "register_navTitle": "CREATE AN ACCOUNT",
        "register_nativeLanguage": "Native Language",
        "register_name": "*Name",
        "register_middleName": "Middle Name",
        "register_surname": "*Surname",
        "register_email": "*Email",
        "register_gender": "Gender",
        "register_password": "*Password",
        "register_createAccount": "CREATE ACCOUNT"
      },
      "email_verification": {
        "emailVerify_title": "THANKS!",
        "emailVerify_mess": "We just need to verify your email address. Please click on the link we email you.",
        "emailVerify_button": "OK"
      },
      "complete_registration": {
        "complete_navTitle": "COMPLETE REGISTRATION",
        "completeReg_title": "HEY",
        "completeReg_mess": "Please fill in required fields below so we can finalise your registration.",
        "completeReg_gender": "Gender",
        "completeReg_nativeLanguage": "Native Language",
        "completeReg_completeBtn": "COMPLETE",
        "completeReg_deleteBtn": "DELETE ACCOUNT"
      },
      "login": {
        "login_navTitle": "LOG IN",
        "login_email": "Email",
        "login_password": "Password",
        "login_btn": "LOGIN"
      },
      "forgot_password": {
        "forgot_navTitle": "FORGOT PASSWORD",
        "forgot_title": "FORGOT YOUR PASSWORD?",
        "forgot_mess": "Not a problem! Enter your email below and we’ll email you a reset link.",
        "forgot_email": "Email",
        "forgot_btn": "EMAIL ME RESET LINK"
      },
      "main_menu": {
        "menu_search": "Search",
        "menu_audio": "My Audio",
        "menu_account": "My Account",
        "menu_language": "Language Preference",
        "menu_logout": "Log Out"
      },
      "app_language_select": {
        "appLanguage_navTitle": "CHOOSE APP LANGUAGE"
      },
      "my_account": {
        "account_compKey": "Comp Key: ",
        "account_btn": "MANAGE SUBSCRIPTION"
      },
      "edit_profile": {
        "editProfile_navTitle": "EDIT PROFILE",
        "editProfile_name": "*Name",
        "editProfile_middleName": "Middle Name",
        "editProfile_surname": "*Surname",
        "editProfile_gender": "Gender",
        "editProfile_password": "Password",
        "editProfile_updateBtn": "UPDATE MY PROFILE",
        "editProfile_deactive": "DEACTIVATE ACCOUNT"
      },
      "subscription": {
        "sub_navTitle": "SUBSCRIPTION",
        "sub_navTitleExisting": "MY SUBSCRIPTION",
        "sub_title": "POWER UP",
        "sub_titleExisting": "POWER USER",
        "sub_mess": "Hi, want to use personal recording feature? Simply choose your plan below or enter company key.",
        "sub_messExisting": "Hey, looks like you’re a Power User. You can mange your subscription below.",
        "sub_subscriptionBtn": "Yearly $3 USD",
        "sub_restore": "RESTORE APP STORE PURCHASE",
        "sub_manage": "MANAGE MY SUPSCRIPTION",
        "sub_compKey": "Company Key",
        "sub_useCompKey": "USE COMPANY KEY",
        "sub_removeCompKey": "REMOVE COMPANY KEY"
      },
      "main_search": {
        "mainSearch_name": "name",
        "mainSearch_user": "user",
        "mainSearch_namePlaceholder": "Search for generic recording",
        "mainSearch_userPlaceholder": "Search for generic recording"
      },
      "search_result": {
        "search_upvote": "Upvote",
        "search_upvoted": "Upvoted",
        "search_report": "Report",
        "search_reported": "Reported"
      },
      "record_generic_name": {
        "recordGeneric_title": "Type in Name to Record",
        "recordGeneric_titleAlready": "Hold Record and Say...",
        "recordGeneric_titleRecording": "Recording...",
        "recordGeneric_wait": "Please wait...",
        "recordGeneric_confirm": "Confirm Recording..."
      },
      "record_personal_name": {
        "recordPersonal_title": "Please record your name",
        "recordPersonal_titleRecording": "Please record your name",
        "recordPersonal_wait": "Please record your name",
        "recordPersonal_mess": "Please record your name",
        "recordPersonal_confirm": "Please record your name"
      },
      "my_audio": {
        "audio_mess": "This audio will be related to your QR Code."
      }
    }
  }'
  param :language, String, :desc => "Choice language to get available!", :required => true
  def index
    params[:language] = "English" if params[:language].blank?
    language = Language.find_by(name: params[:language])
    available_languages = language.available_languages.select(:screen_key, :screen_fields)
    result = {}
    available_languages.each do |avl|
      result[avl.screen_key] = avl.screen_fields
    end
    render json: success_message("Get successfully!", result)
  end

  api :GET, '/available_languages/list_available', "Get list available languages"
  example '
  {
    "code": 200,
    "message": "Get successfully!",
    "data": {
      "show_company_code": true,
      "available_languages": [
        "English"
      ]
    }
  }'
  def list_available
    available_languages = Language.publish.pluck(:name).uniq
    render json: success_message("Get successfully!", {
        show_company_code: Setting.first.show_company_text,
        available_languages: available_languages
      })
  end
end
