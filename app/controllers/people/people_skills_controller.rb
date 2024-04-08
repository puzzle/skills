# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [{ people_skills_attributes: [:id, :certificate, :level,
                                                       :interest, :core_competence, :_destroy] }]
  helper_method :people_skills_of_category

  def index
    @person = Person.find(params[:id])
    super
  end

  def edit
    @person = Person.find(params[:id])
    super
  end

  def self.model_class
    Person
  end

  def show_path
    people_skills_person_path(@person)
  end

  private

  def people_skills_of_category(category)
    @person.people_skills.where(skill_id: category.skills.pluck(:id))
  end

end
