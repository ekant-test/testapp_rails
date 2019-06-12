class Admin::RecordingsController < Admin::BaseController
  before_action :load_recording, only: :destroy
  def index
    @q = Recording.ransack(params[:q])
    @recordings =@q.result
  end

  def destroy
    if @recording.destroy
      flash[:notice] = "Destroy translation successfully!"
    else
      flash[:error] = "Destroy translation fail!"
    end
    redirect_to admin_recordings_path
  end

  private
    def load_recording
      if params[:recording_id].present?
        @recording = Recording.find(params[:recording_id])
      else
        @recording = Recording.find(params[:id])
      end
    end
end
