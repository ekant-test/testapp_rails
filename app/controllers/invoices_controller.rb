class InvoicesController < ApplicationController
  layout "pdf"
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def index
    @invoice = Stripe::Invoice.retrieve(params[:id])
    @company = Company.find(params[:company_id])
    @user = User.find(@company.owner_id) if @company.present?
  end
end
