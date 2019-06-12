class Company::PlansController < Company::BaseController
  def create
    ActiveRecord::Base.transaction do
      begin
        if current_user.stripe_customer_id.present?
          create_plan
          if current_user.plans.trail.blank?
            flash[:error] = "Please choose a plan!"
            redirect_to :back and return
          end
          current_user.create_subscription
          current_user.plans.trail.update_all(date_purchased: Date.today, date_expire: Date.today + 1.year)
          flash[:notice] = "Update plans!"
          current_user.company.update!(status: true) if current_user.company.try(:status).blank?
          redirect_to :back and return
        else
          flash[:error] = "You are not have credit card!"
          redirect_to :back and return
        end
      rescue => e
        rescue_stripe_errors(e)
        raise ActiveRecord::Rollback
      end
    end
    redirect_to :back and return
  end

  private
    def create_plan
      if params[:plan_base].present?
        plan = current_user.plans.find_by(name: Plan::NAME[:plan_base])
        plan_attr = {
            name: Plan::NAME[:plan_base],
            amount: params[:price_base_plan],
            description: Plan::NAME[:plan_base],
            date_purchased: nil,
            date_expire: nil
          }
        if plan.blank?
          current_user.plans.create!(plan_attr)
        else
          # plan.update!(plan_attr)
        end
      end

      if params[:plan_single].to_i > 0
        plan = current_user.plans.find_by(name: Plan::NAME[:plan_single], number: params[:plan_single].to_i)
        plan_attr = {
            name: Plan::NAME[:plan_single],
            # amount: params[:price_plan_single].to_f,
            amount: params[:price_plan_single].to_f * params[:plan_single].to_f,
            description: Plan::NAME[:plan_single],
            date_purchased: nil,
            date_expire: nil,
            number: params[:plan_single].to_i
          }
        if plan.blank?
          current_user.plans.create!(plan_attr)
        else
          # plan.update!(plan_attr)
        end
      end

      [10, 25, 100, 1000].each do |id|
        if params["plan_#{id}"].present?
          plan = current_user.plans.find_by(name: Plan::NAME["plan_#{id}".to_sym])
          plan_attr = {
              name: Plan::NAME["plan_#{id}".to_sym],
              amount: params["price_plan_#{id}"],
              description: params["plan_#{id}"] + " Users",
              date_purchased: nil,
              date_expire: nil
            }
          if plan.blank?
            current_user.plans.create!(plan_attr)
          else
            # plan.update!(plan_attr)
          end
        end
      end
    end
end
