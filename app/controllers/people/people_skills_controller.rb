# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [{ people_skills_attributes: [:id, :certificate, :level, :interest,
                                                       :core_competence, :skill_id, :unrated,
                                                       :_destroy] }]
  before_action :set_person

  def self.model_class
    Person
  end

  def update
    if params[:person].blank?
      render(:index, status: :ok)
      return
    end
    super do |format, success|
      format.turbo_stream { render 'people/people_skills/update', status: :ok } if success
    end
  end

  def show_path
    person_people_skills_path(@person)
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end
end
