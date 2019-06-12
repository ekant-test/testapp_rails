class PlansController < ApplicationController
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        plan = Plan.find(params[:id])
        if plan.name == Plan::NAME[:plan_single]
          plan_name = "#{plan.number} #{plan.name}"
        else
          plan_name = plan.name
        end
        stripe_customer = plan.user.stripe_customer
        subscriptions = stripe_customer.subscriptions.data rescue []
        subscriptions.each do |sb|
          sb.delete(:at_period_end => true) if sb.items.data.first.plan.name == plan_name
        end

        # invoices = stripe_customer.invoices.data rescue []
        # invoices.each do |i|
        #   if i.lines.data.first.plan.name == plan_name
        #     i.closed = true
        #     i.save
        #   end
        # end

        plan.destroy!
        flash[:notice] = "Cancel plan successfully!"
      rescue
        flash[:notice] = "Cancel plan fail!"
      end
    end
    redirect_to :back
  end
end
