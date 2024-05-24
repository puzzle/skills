# frozen_string_literal: true

class People::PeopleSkillsCreateController < CrudController
  include ParamConverters
  self.permitted_attrs = [:certificate, :level, :interest, :core_competence, :skill_id, :skill_ids,
                          { skill_attributes:
                          [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  self.nesting = Person
  helper_method :people_skills_of_category
  layout 'person'

  def index
    if params[:rating].blank?
      redirect_to url_for(request.params.merge(rating: 0))
      return
    end
    super
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
    rating = params[:rating]
    return filter_by_rating(super, rating) if rating.present?

    super
  end

  def filter_by_rating(people_skills, rating)
    if rating == '0'
      return people_skills.where('level > ?', 0)
    end

    if rating == '-1'
      return people_skills.where(level: 0)
    end

    people_skills
  end

  def self.controller_path
    'people/people_skills'
  end

  def people_skills_of_category(category)
    @people_skills.where(skill_id: category.skills.pluck(:id))
  end
end
