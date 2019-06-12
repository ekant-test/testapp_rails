class AvailableLanguagesSerializer < ActiveModel::Serializer
  attributes :id, :language, :menu_search, :menu_audio, :menu_account, :menu_language
end
