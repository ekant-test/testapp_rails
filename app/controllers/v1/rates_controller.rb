class V1::RatesController < V1::BaseController
  before_action :auth_user

  api :POST, '/recordings/1/rates', "Upvote/Report an recording"
  example 'Upvote
  {
    "code": 200,
    "message": "upvote successfully!",
    "data": {
      "success": true,
      "rate_type": "upvote"
    }
  }'
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  error :code => 500, :desc => "Rated current recording"
  param :recording_id, String, :desc => "Recording ID", :required => false
  param :rate_type, String, :desc => "Rate type", :required => false
  def create
    rate = current_user.rates.find_by(recording_id: params[:recording_id], rate_type: params[:rate_type])
    success = false
    if rate.blank?
      rate = current_user.rates.new(rate_params)
      if rate.save
        success = true
        render json: success_message("#{params[:rate_type]} successfully!", {success: success, rate_type: params[:rate_type]})
      else
        render json: error_message("Can't #{params[:rate_type]}", {success: success, rate_type: params[:rate_type]})
      end
    else
      render json: error_message("You are rated for this recording!", {success: success, rate_type: params[:rate_type]})
    end
  end

  private
    def rate_params
      params.permit(:rate_type, :recording_id)
    end
end
