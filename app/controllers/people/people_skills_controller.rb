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
    rating = params[:rating]
    return super if rating.present? && ratings.has_value?(rating)

    redirect_to url_for(request.params.merge(rating: 0))
  end

  def show
    redirect_to person_people_skills_path(@person)
  end

  def new
    super
    @people_skill.skill ||= Skill.new
  end

  def update
    @people_skills = filtered_people_skills(params[:people_skill])
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
    if rating == ratings[:rated_value]
      return people_skills.where('level > ?', 0) # Returns all rated skills
    elsif rating == ratings[:unrated_value]
      unless current_skill.nil? # Checks if currently a unrated skill is getting rated
        # If yes we add the currently rated skill so he doesnt disappear
        return people_skills.where(level: 0)
                            .or(people_skills.where(skill_id: current_skill[:skill_id]))
      end
      return people_skills.where(level: 0) # Returns all unrated skills
    end

    people_skills # If the rating is neither 1 or 0 it returns all
  end

  def ratings
    {
      all_value: '1',
      rated_value: '0',
      unrated_value: '-1'
    }
  end
end
