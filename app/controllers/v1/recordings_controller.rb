class V1::RecordingsController < V1::BaseController
  before_action :load_recording, only: :show
  before_action :auth_user, only: :create

  api :GET, '/recordings?name=Asimpe', "List recordings and result search recordings"
  example '
  {
    "code": 200,
    "message": "Search successfully!",
    "data": {
      "results": [
        {
          "id": 102,
          "name": "Thua Ha",
          "email": null,
          "native_name": "",
          "language": "English",
          "record_url": "http://ideabox-nomen-upload.s3.amazonaws.com/audios/recordings/record_files/data-e98ce5516dd25e862957567b7faff9696a822a55.?1479368009",
          "record_type": "User",
          "qr_code": "e5e5dd785a0ebeaa6d28a2d9eb3c43b5470473989bb1e49dff",
          "reported": false,
          "upvoted": false
        }
      ]
    }
  }'
  param :name, String, :desc => "Choice name to get recordings!"
  def index
    results = Recording.search(params[:name], params[:language], params[:record_type], params[:action_type])
    render json: success_message("Search successfully!", {
      results: ActiveModel::ArraySerializer.new(results, each_serializer: SearchResultsSerializer, scope: {user_id: current_user.try(:id)})
      })
  end

  api :GET, 'recordings/get_by_qr_code?qr_code=e5e5dd785a0ebeaa6d28a2d9eb3c43b5470473989bb1e49dff', "Show recording by qr_code"
  example '
  {
    "code": 200,
    "message": "Search successfully!",
    "data": {
      "results": {
        "id": 102,
        "name": "Thua Ha",
        "email": "vovantri92+1@gmail.com",
        "native_name": "",
        "language": "English",
        "record_url": "http://ideabox-nomen-upload.s3.amazonaws.com/audios/recordings/record_files/data-e98ce5516dd25e862957567b7faff9696a822a55.?1479368009",
        "record_type": "User",
        "qr_code": "e5e5dd785a0ebeaa6d28a2d9eb3c43b5470473989bb1e49dff",
        "reported": false,
        "upvoted": true
      }
    }
  }'
  param :qr_code, String, :desc => "Choice qr_code to get recording!"
  def get_by_qr_code
    recording = Recording.find_by(qr_code: params[:qr_code])
    if recording.present?
      render json: success_message("Search successfully!", {
        results: SearchResultsSerializer.new(recording, scope: {user_id: current_user.try(:id)}).serializable_hash
        })
    else
      render json: error_message("Can't find recording!", '')
    end
  end

  api :POST, '/recordings', "Create an recording"
  example '
  {
    "code": 200,
    "message": "Create recording successfully!",
    "data": {
      "id": 107,
      "name": "tri",
      "email": "vovantri92+1@gmail.com",
      "native_name": "",
      "language": "English",
      "record_url": "",
      "record_type": "name",
      "qr_code": "",
      "reported": false,
      "upvoted": false
    }
  }'
  error :code => 401, :desc => "Unauthorized"
  param :name, String, :desc => "Name", :required => true
  param :record_file, String, :desc => "Choice file record", :required => true
  param :language, String, :desc => "language", :required => true
  param :record_type, String, :desc => "type: User/Name", :required => true
  def create
    if params[:record_type].downcase == 'user'
      old_recordings = current_user.recordings.where("lower(record_type) = '#{params[:record_type].downcase}'").destroy_all
    else
      if recording_params[:native_name].present?
        native_name = recording_params[:native_name].downcase
        recordings = Recording.where("lower(language) = '#{params[:language].downcase}' and lower(native_name) = '#{native_name}'")
      else
        recordings = Recording.where("lower(language) = '#{params[:language].downcase}' and lower(name) = '#{recording_params[:name].downcase}'")
      end
      if recordings.size >= 3
        data = []
        recordings.each do |rd|
          count_upvotes = rd.rates.where(rate_type: 'upvote').size
          count_reports = rd.rates.where(rate_type: 'report').size
          data << {recording: rd, rate: (count_upvotes - count_reports)}
        end
        data = data.sort_by { |d| d[:rate] }
        data_delete = data.first
        data_delete[:recording].destroy!
      end
    end
    recording = current_user.recordings.new(recording_attrs)
    recording.qr_code = SecureRandom.hex(25) if params[:record_type].downcase == 'user'
    if recording.save
      render json: success_message("Create recording successfully!", SearchResultsSerializer.new(recording, scope: {user_id: current_user.try(:id)}).serializable_hash)
    else
      render json: error_message("Create recording fail!", recording.errors.full_messages.join(","))
    end
  end

  api :GET, '/recordings/autocomplete', "Autocomplete recordings when input"
  example '
  {
    "code": 200,
    "message": "Auto complete successfully!",
    "data": {
      "results": [
        "Thua Ha",
        "Thua Handsome"
      ]
    }
  }
  '
  param :name, String, :desc => "Choice name to get name of recordings!", :required => true
  def autocomplete
    if params[:name].blank?
      results = []
    else
      recordings = Recording.search(params[:name], params[:language], params[:record_type], params[:action])
      if !!params[:name].match(/^[a-zA-Z0-9_\-+ ]*$/)
        results = recordings.pluck(:name).uniq
      else
        results = recordings.pluck(:native_name).uniq
      end
    end
    render json: success_message("Auto complete successfully!", {
      results: results
      })
  end

  private
    def load_recording
      @recording = Recording.find_by(id: params[:id])
      if @recording.blank?
        render json: error_message("Record not found!")
      end
    end

    def recording_params
      params.permit(:name, :record_file, :language, :record_type, :native_name)
    end

    def recording_attrs
      record_file = params[:record_file].present? ? 'data:audio/mp3;base64,' + params[:record_file] : ''
      recording_params.merge!({record_file: record_file})
    end
end
