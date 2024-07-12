# frozen_string_literal: true

class People::PeopleSkillsCreateController < CrudController
  include ParamConverters
  self.permitted_attrs = [:certificate, :level, :interest, :core_competence, :skill_id, :skill_ids,
                          { skill_attributes:
                          [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  self.nesting = Person
  layout 'person'

  helper_method :ptime_broken?

  def index
    return super if params[:rating].present?

    redirect_to url_for(request.params.merge(rating: 0))
  end

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

  def list_entries
    return super if params[:rating].blank?

    filter_by_rating(super, params[:rating])
  end

  def filter_by_rating(people_skills, rating)
    return people_skills.where('level > ?', 0) if rating == '0'
    return people_skills.where(level: 0) if rating == '-1'

    people_skills
  end

  def self.controller_path
    'people/people_skills'
  end

  def ptime_broken?
    !ActiveModel::Type::Boolean.new.cast(ENV.fetch('PTIME_API_ACCESSIBLE', true))
  end
end
