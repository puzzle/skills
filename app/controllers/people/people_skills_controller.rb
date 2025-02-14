# frozen_string_literal: true

class People::PeopleSkillsController < CrudController
  include ParamConverters
  self.permitted_attrs = [{ people_skills_attributes: [[:id, :certificate, :level, :interest,
                                                        :core_competence, :skill_id, :unrated,
                                                        :_destroy]] }]
  before_action :set_person

  def self.model_class
    Person
  end

  def update
    @people_skills = filtered_people_skills
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
