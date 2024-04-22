# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [{ people_skills_attributes: [:id, :certificate, :level,
                                                       :interest, :core_competence, :_destroy] }]
  helper_method :people_skills_of_category
  before_action :set_person

  def self.model_class
    Person
  end

  def update
    if params[:person].blank?
      render(:index, status: :ok)
    else
      super
    end
  end

  def show_path
    people_skills_person_path(@person)
  end

  private

  def people_skills_of_category(category)
    @person.people_skills.where(skill_id: category.skills.pluck(:id))
  end

  def set_person
    @person = Person.find(params[:id])
  end

  def unrated_by_person
    if params[:person_id].present?
      entries = Skill.default_set.where
                     .not(id: PeopleSkill.where(person_id: params[:person_id]).select(:skill_id))
    else
      entries = Skill.list
    end
    render json: entries, each_serializer: SkillMinimalSerializer, include: '*'
  end

end
