class Company::AccountController < Company::BaseController
  def index
    @plans = current_user.plans
    @company = current_user.company
    get_invoices
  end

  def create
    company = current_user.company
    ActiveRecord::Base.transaction do
      company.update!(name: params[:company_name])
      if current_user.update(user_params)
        if params[:password].present? && params[:password_confirmation]
          current_user.reset_password(params[:password], params[:password_confirmation])
          flash[:notice] = "Update account info successfully!"
        end
      else
        flash[:notice] = "Update account info fail!"
      end
    end

    redirect_to company_account_index_path
  end

  def destroy
    current_user.lock_access!
    sign_out(current_user)
    redirect_to company_account_index_path
  end

  def remove_card
    current_user.deactive_subscriptions
    redirect_to :back, notice: 'Removed card'
  end

  def get_invoices
    @invoices ||= Kaminari.paginate_array(invoice_for_current_user)
      .page(params[:page])
  end

  def invoice_for_current_user
    Stripe::Customer.retrieve(current_user.stripe_customer_id).invoices.data rescue []
  end

  private
    def user_params
      params.permit(:email, :name, :sur_name)
    end
end
