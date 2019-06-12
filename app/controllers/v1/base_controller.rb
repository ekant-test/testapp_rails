class V1::BaseController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :auto_login
  before_action :set_api_token
  protected
    def auth_user
      render json: (token_invalid_message(I18n.t("messages.errors.please_sign_in"))) and return if current_user.blank?
      render json: (error_message(I18n.t("messages.errors.missing_api_token"))) and return unless api_token?
      render json: (token_invalid_message) and return unless valid_token?
    end

    def success_message(message, content={})
      ResponseTemplate.success(message, content)
    end

    def error_message(message, content={})
      ResponseTemplate.error(message, content)
    end

    def error_permission(message, content={})
      ResponseTemplate.error_permission(message, content)
    end

    def token_invalid_message(msg = I18n.t("messages.errors.api_token_invalid"))
      ResponseTemplate.token_invalid(msg)
    end

  private
    def set_api_token
      cookies[:api_token] = current_user.try(:api_token) || ''
    end

    def api_token?
      request.headers["Api-Token"].present?
    end

    def session_api_token
      request.headers["Api-Token"]
    end

    def valid_token?
      current_user.api_token == session_api_token
    end

    def auto_login
      if api_token? && current_user.blank? && !(['v1/languages', 'v1/available_languages'].include?(params[:controller]))
        user = User.find_by(api_token: session_api_token)
        if user.present?
          sign_in(user)
        end
      end
    end
end
