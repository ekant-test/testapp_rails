class Company::BillingDetailsController < Company::BaseController

  def update
    if params[:stripeToken].present?
      begin
        current_user.create_or_update_stripe_customer(params[:stripeToken])
        flash[:success] = 'Billing details updated succesfully'
        redirect_to :back
      rescue => e
        rescue_stripe_errors(e)
        redirect_to :back
      end
    else
      redirect_to :back
      flash[:error] = 'Please Refesh page if you want to add another card.'
    end
  end

  def edit
    @stripe_info = StripeServices.new.info_card(current_user)
  end
end
