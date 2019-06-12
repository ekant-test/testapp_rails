module Stripeable
  extend ActiveSupport::Concern

  def has_stripe?
    stripe_customer_id.present? && cards.any?
  end

  def create_or_update_stripe_customer(token)
    if stripe_customer_id.present?
      update_billing_details(token)
    else
      create_stripe_customer(token)
    end
  end

  def create_subscription
    if stripe_subscription_id.present?
      renew_subscription
    else
      self.plans.trail.each do |plan|
        if [Plan::NAME[:plan_single], Plan::NAME[:plan_base]].include?(plan.name)
          plan_name = "#{plan.number} #{plan.name}"
          stripe_plan = init_stripe_plan(plan_name, plan.amount)
          subscription = Stripe::Subscription.create(customer: stripe_customer_id, plan: stripe_plan.id)
        else
          plan_name = plan.name
          subscription = stripe_customer.subscriptions.create({plan: plan_name})
        end
        update(stripe_subscription_id: subscription.id)
      end
    end
  end

  def deactive_subscriptions
    if has_stripe?
      stripe_customer.subscriptions.each do |subscription|
        subscription.delete(at_period_end: true)
      end

      cards.each do |card|
        card.delete
      end
    end
    update(stripe_customer_id: nil, stripe_subscription_id: nil)
  end

  def renew_subscription
    if stripe_subscription_id.present?
      self.plans.trail.each do |plan|
        if [Plan::NAME[:plan_single], Plan::NAME[:plan_base]].include?(plan.name)
          plan_name = "#{plan.number} #{plan.name}"
          stripe_plan = init_stripe_plan(plan_name, plan.amount)
          subscription = Stripe::Subscription.create(customer: stripe_customer_id, plan: stripe_plan.id)
        else
          subscription = stripe_subscription
          plan_name = plan.name
          subscription.plan = plan_name
          subscription.save
        end
        update(stripe_subscription_id: subscription.id)
      end
    end
  end

  def cards
    stripe_customer.sources.all(:object => "card").data
  end

  def init_stripe_plan(plan_name, amount = 2.8)
    stripe_plan = Stripe::Plan.list.data.select{|plan| plan.id == plan_name }.first
    if stripe_plan.present?
      stripe_plan
    else
      stripe_plan = Stripe::Plan.create(amount: (amount.round(2) * 100).to_i, interval: "year", name: plan_name, 
        currency: "USD", id: plan_name)
    end
    stripe_plan
    # sb = Stripe::Subscription.create(customer: stripe_customer_id, plan: stripe_plan.id)
  end

  def update_billing_details(token)
    customer = stripe_customer
    customer.card = token
    customer.save
  end

  def stripe_subscription
    Stripe::Subscription.retrieve(stripe_subscription_id)
  end

  def create_stripe_customer(token)
    customer = Stripe::Customer.create(
      email: self.email,
      card: token,
      description: name
    )

    update(stripe_customer_id: customer.id)
  end

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end
end