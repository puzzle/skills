# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [:id, :certificate, :level, :interest, :core_competence,
                          :skill_id, :unrated, :skill_ids, :_destroy,
                          { skill_attributes:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]

  self.nesting = Person
  layout 'person'

  def self.model_class
    PeopleSkill
  end

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

  def update
    @people_skills = filtered_people_skills
    super do |format, success|
      format.turbo_stream { render 'people/people_skills/update', status: :ok } if success
    end
  end

  def list_entries
    return super if params[:rating].blank?

    filter_by_rating(super, params[:rating])
  end

  def show_path
    person_people_skills_path(@person)
  end

  private

  def filtered_people_skills
    return @person.people_skills if params[:rating].blank?

    filter_by_rating(@person.people_skills, params[:rating])
  end

  def filter_by_rating(people_skills, rating)
    return people_skills.where('level > ?', 0) if rating == '0'
    return people_skills.where(level: 0) if rating == '-1'

    people_skills
  end
end
