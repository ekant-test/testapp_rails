class Company::BaseController < ApplicationController
  before_filter :auth_user
  before_filter :sidebar
  before_filter :load_card

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def load_card
    @stripe_info = 
      if current_user.stripe_customer_id.present?
        begin
          stripe = Stripe::Customer.retrieve(current_user.stripe_customer_id)
          info = stripe['sources']['data'].first
          {
            last_4digist: info['last4'],
            brand: info['brand'],
            exp_month: info['exp_month'],
            exp_year: info['exp_year']
          }
        rescue => e
          {}
        end
      else
        {}
      end
  end

  def sidebar
    @hide_side_bar = "pushy-open" 
  allowed_users = 0
  current_user.plans.each do |plan|
    allowed_users +=
      case plan.name
      when Plan::NAME[:plan_single]
        plan.number
      when Plan::NAME[:plan_base]
        10
      when Plan::NAME[:plan_10]
        10
      when Plan::NAME[:plan_25]
        25
      when Plan::NAME[:plan_100]
        100
      when Plan::NAME[:plan_1000]
        1000
      end
    end
    @hide_side_bar = "pushy-left" if allowed_users - current_user.company.try(:count_user_use_key).to_i > 5
  end
end
