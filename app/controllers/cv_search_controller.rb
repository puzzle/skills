# frozen_string_literal: true

class CvSearchController < ApplicationController
  before_action :prepare_search_data, only: [:index, :search]
  def index
  end

  def search
    respond_to do |format|
      format.turbo_stream { render 'cv_search/form_update', status: :ok }
      format.html { render :index }
    end
  end

  private

  def prepare_search_data
    @query_too_short = query.blank? || query.any? { |q| q.strip.length < 3 }
    @search_skills = search_skills?

    @cv_search_results = should_search? ? people_search.entries : []

    @associations = exclude_skills
    @personal_details = (PeopleSearch::PERSONAL_DETAILS + PeopleSearch::CORE_COMPETENCES)

    @attributes = {
      t('cv_search.personal_data') => translate_attributes(@personal_details),
      t('cv_search.associations') => translate_attributes(@associations)
    }
  end

  def people_search
    PeopleSearch.new(
      query,
      search_skills: @search_skills,
      categories: params[:category],
      handle_whitespaces: handle_whitespaces?
    )
  end

  def query
    params[:q].to_s.split(',').map(&:strip).compact_blank
  end

  def translate_attributes(attributes)
    attributes.map do |attribute|
      translated = t("activerecord.attributes.person.#{attribute}.other",
                     default: :"activerecord.attributes.person.#{attribute}")

      [translated, attribute]
    end
  end

  def exclude_skills
    @search_skills ? PeopleSearch::ASSOCIATIONS : PeopleSearch::ASSOCIATIONS - [:skills]
  end

  def search_skills?
    ActiveModel::Type::Boolean.new.cast(params.fetch(:search_skills, false))
  end

  def handle_whitespaces?
    params.key?(:handle_whitespaces)
  end

  def should_search?
    params[:q].present? && !@query_too_short
  end
end
