# frozen_string_literal: true

class SkillSearchController < CrudController
  def self.model_class = PeopleSkill

  before_action :set_search

  private

  def set_search
    @search = SkillSearch::Search.new(params)
    @search.apply_filters
  end
end
