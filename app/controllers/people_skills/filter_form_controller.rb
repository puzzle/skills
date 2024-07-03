# frozen_string_literal: true

class PeopleSkills::FilterFormController < CrudController
  include ParamConverters

  helper_method :filter_params

  def self.model_class
    PeopleSkill
  end

  def self.controller_path
    'people_skills/filter_form'
  end

  private

  def filter_params
    PeopleSkills::FilterParams.new(params)
  end
end
