class Admin::CompaniesController < Admin::BaseController
  before_action :load_company, only: [:destroy, :active, :deactive, :show]
  def index
    @q = Company.ransack(params[:q])
    @companies =@q.result
  end

  def show
    @user = User.find(@company.owner_id)
    get_invoices
  end

  def create
  end

  # def invoice
  #   @invoice = Stripe::Invoice.retrieve(params[:id])
  #   @company = Company.find(params[:company_id])
  #   @user = User.find(@company.owner_id) if @company.present?
  # end

  def active
    if @company.update(status: true)
      @user = User.find(@company.owner_id).unlock_access!
      flash[:notice] = "Activate company successfully!"
    else
      flash[:notice] = "Activate company fail!"
    end
    redirect_to admin_companies_path
  end

  def deactive
    if @company.update(status: false)
      @user = User.find(@company.owner_id).lock_access!
      flash[:notice] = "Deactivate company successfully!"
    else
      flash[:notice] = "Deactivate company fail!"
    end
    redirect_to admin_companies_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      owner = User.find_by(id: @company.owner_id)
      owner.deactive_subscriptions if owner.present?
      if @company.destroy
        flash[:notice] = "Destroy company successfully!"
      else
        flash[:error] = "Destroy company fail!"
      end
    end
    redirect_to admin_companies_path
  end

  def destroy_plan
    plan = Plan.find(params[:id])
    plan.destroy!
    flash[:notice] = "Cancel plan successfully!"
    redirect_to :back
  end

  private
  def load_company
    @company = Company.find params[:id]
  end

  def get_invoices
    @invoices ||= Kaminari.paginate_array(invoice_for_current_user)
      .page(params[:page])
  end

  def invoice_for_current_user
    Stripe::Customer.retrieve(@user.stripe_customer_id).invoices.data rescue []
  end
end
