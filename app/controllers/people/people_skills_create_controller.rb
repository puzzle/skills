# frozen_string_literal: true

class People::PeopleSkillsCreateController < CrudController
  include ParamConverters
  self.permitted_attrs = [:certificate, :level, :interest, :core_competence, :skill_id, :skill_ids,
                          { skill_attributes:
                          [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  self.nesting = Person
  helper_method :people_skills_of_category
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

  def entries # rubocop:disable Metrics/MethodLength
    rating = params[:rating] || '0'
    list = super
    if rating == '1'
      list = super
    end

    if rating == '0'
      list = super.where('level > ?', 0)
    end

    if rating == '-1'
      list = super.where(level: 0)
    end

    model_ivar_set(list)
  end

  def self.controller_path
    'people/people_skills'
  end

  def people_skills_of_category(category)
    model_ivar_get(plural: true).where(skill_id: category.skills.pluck(:id))
  end
end
