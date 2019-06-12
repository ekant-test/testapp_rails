class Admin::LanguagesController < Admin::BaseController
  before_action :load_language, only: [:change_status, :destroy, :show, :update]
  def index
    @q = Language.ransack(params[:q])
    @languages =@q.result
  end

  def new
    load_english
    @language = Language.new
    @available_languages = []
    available_languages = YAML.load_file Rails.root.join('db/data/available_language_template.yml')
    available_languages.each do |al|
      screen_key = al["screen_name"].underscore.gsub(' ', '_')
      attr_params = al.merge(screen_key: screen_key)
      @available_languages << AvailableLanguage.new(attr_params)
    end
  end

  def show
    load_english
  end

  def create
    language = Language.new(language_params)
    if language.save
      available_languages = YAML.load_file Rails.root.join('db/data/available_language_template.yml')
      available_languages.each do |al|
        screen_key = al["screen_name"].underscore.gsub(' ', '_')
        attr_params = al.merge(screen_key: screen_key)
        available_language = language.available_languages.new(attr_params)
        available_language.screen_fields.each do |screen_field|
          available_language.screen_fields[screen_field[0]] = params[screen_field[0]]
        end
        available_language.save!
      end
      flash[:notice] = "Create translation successfully!"
      redirect_to admin_language_path(language)
    else
      flash[:error] = "Create translation fail!"
      redirect_to new_admin_language_path
    end
  end

  def update
    if @language.update(language_params)
      @language.available_languages.each do |al|
        al.screen_fields.each do |screen_field|
          al.screen_fields[screen_field[0]] = params[screen_field[0]] if params[screen_field[0]].present?
        end
        al.save!
      end
      flash[:notice] = "Udate translation successfully!"
      redirect_to admin_language_path(@language)
    else
      flash[:error] = "Udate translation fail!"
      redirect_to admin_language_path(@language)
    end
  end

  def change_status
    status = @language.status ? false : true
    if @language.update(status: status)
      flash[:notice] = @language.status ? 'Published' : 'Unpublished'
    else
      flash[:error] = "Can't change status!"
    end
    redirect_to admin_languages_path
  end

  def destroy
    if @language.destroy
      flash[:notice] = "Destroy translation successfully!"
    else
      flash[:error] = "Destroy translation fail!"
    end
    redirect_to admin_languages_path
  end

  private
    def load_language
      if params[:language_id].present?
        @language = Language.find(params[:language_id])
      else
        @language = Language.find(params[:id])
      end
    end

    def load_english
      @language_english = Language.find_by(name: "English")
    end

    def language_params
      params.permit(:name, :status)
    end
end
