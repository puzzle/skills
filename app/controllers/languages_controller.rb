require 'i18n_data'
require 'language_list'
class LanguagesController < ApplicationController

  def index
    languages = common_languages.collect.with_index do |language, i|
      { type: 'language', id: i + 1, attributes: { iso1: language[0], name: language[1] } }
    end
    render json: { data: languages }
  end

  private

  def common_languages
    @common_languages ||= I18nData.languages('DE').collect do |language|
      info = LanguageList::LanguageInfo.find(language[0])
      if info && info.common?
        language
      end
    end.compact
  end
end
