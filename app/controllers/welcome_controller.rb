class WelcomeController < ActionController::Base
  layout 'dashboard'
  def index
  end

  def terms
    @term = Term.first
  end

  def reset_password
    original_token = params[:reset_password_token]
    recoverable = User.find_by(reset_password_token: original_token)
    if recoverable.persisted?
      if recoverable.reset_password_period_valid?
        if recoverable.reset_password(params[:password], params[:password_confirmation])
          flash[:errors] = "reset password successfully!"
          redirect_to :back
        else
          flash[:errors] = recoverable.errors.full_messages.first
          redirect_to :back
        end
      else
        recoverable.errors.add(:reset_password_token, :expired)
        flash[:errors] = recoverable.errors.full_messages.first
        redirect_to :back
      end
    end
  end
end
