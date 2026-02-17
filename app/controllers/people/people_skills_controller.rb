# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters

  RATED_VALUE = '0'
  UNRATED_VALUE = '-1'

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
    rating = params[:rating]
    unless rating.present? && [1, 0, -1].include?(rating.to_i)
      redirect_to url_for(request.params.merge(rating: 0))
    end

    super
    @not_rated_default_skills = not_rated_default_skills(@person)
  end

  def show
    redirect_to person_people_skills_path(@person)
  end

  def new
    super
    @people_skill.skill ||= Skill.new
  end

  def create
    if params[:people_skill]&.key?(:edit_form)
      super do |format, success|
        @person = Person.find(params[:person_id])
        @people_skills = filtered_people_skills(params[:people_skill])
        @not_rated_default_skills = not_rated_default_skills(@person)
        format.turbo_stream { render 'people/people_skills/create', status: :ok } if success
      end
    else
      super
    end
  end

  def update
    @people_skills = filtered_people_skills(params[:people_skill])
    @not_rated_default_skills = not_rated_default_skills(@person)
    super do |format, success|
      format.turbo_stream { render 'people/people_skills/update', status: :ok } if success
    end
  end

  def list_entries
    return super if params[:rating].blank?

    filter_by_rating(super, params[:rating])
  end

  def show_path
    person_people_skills_path(@person, rating: params[:rating])
  end

  private

  def filtered_people_skills(current_skill)
    return @person.people_skills if params[:rating].blank?

    filter_by_rating(@person.people_skills, params[:rating], current_skill)
  end

  def filter_by_rating(people_skills, rating, current_skill = nil)
    if rating == RATED_VALUE
      return people_skills.where('level > ?', 0) # Returns all rated skills
    elsif rating == UNRATED_VALUE
      unless current_skill.nil? # Checks if currently a unrated skill is getting rated
        # If yes we add the currently rated skill so he doesnt disappear
        return people_skills.where(level: 0)
                            .or(people_skills.where(skill_id: current_skill[:skill_id]))
      end
      return people_skills.where(level: 0) # Returns all unrated skills
    end

    people_skills # If the rating is neither 1 or 0 it returns all
  end

  def not_rated_default_skills(person)
    not_rated_default_skills =
      Skill.where(default_set: true)
           .where.not(id: PeopleSkill.where(person:).select('skill_id'))

    not_rated_default_skills.map do |skill|
      PeopleSkill.new({ person_id: person.id, skill_id: skill.id, level: 1, interest: 1,
                        certificate: false, core_competence: false })
    end
  end
end
