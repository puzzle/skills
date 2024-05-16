# frozen_string_literal: true

class People::PeopleSkillsCreateController < CrudController
  include ParamConverters
  self.permitted_attrs = [:certificate, :level, :interest, :core_competence, :skill_id, :skill_ids,
                          { skill_attributes:
                          [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  self.nesting = Person
  layout 'person'

  def show
    redirect_to person_people_skills_path(@person)
  end

  def new
    super
    @people_skill.skill ||= Skill.new
    @category_hidden = @people_skill.skill.category&.id.present? && @people_skill.skill&.id.present?
  end

  def self.model_class
    PeopleSkill
  end

  def self.controller_path
    'people/people_skills'
  end
end
