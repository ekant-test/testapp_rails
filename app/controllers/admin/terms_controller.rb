class Admin::TermsController < Admin::BaseController
  def index
    @term = Term.first
  end

  def create
    term =
      if params[:term_id].blank? 
    	Term.new
      else
    	Term.find params[:term_id]
      end
    term.content = params[:content]
    if term.save
      flash[:notice] = "Update user successfully!"
    else
      flash[:error] = "Update user fail!"
    end
    redirect_to :back
  end
end
