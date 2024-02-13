# frozen_string_literal: true

require 'keycloak_tools'

class SkillsController < CrudController
  include ExportController
  include KeycloakTools

  before_action :authorize_admin, except: %i[index show create unrated_by_person]

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  def create
    super(:location => skills_path)
  end

  def unrated_by_person
    if params[:person_id].present?
      entries = Skill.default_set.where
                     .not(id: PeopleSkill.where(person_id: params[:person_id]).pluck(:skill_id))
    else
      entries = Skill.list
    end
    render json: entries, each_serializer: SkillMinimalSerializer, include: '*'
  end

  private

  def fetch_entries
    entries = if params[:format]
                Skill.list
              else
                Skill.includes(:people,
                               parent_category: [:children, :parent],
                               category: [:children, :parent]).list
              end
    SkillsFilter.new(entries, params[:category], params[:title], params[:defaultSet]).scope
  end

  def export
    send_data Csv::Skillset.new(fetch_entries).export,
              type: :csv,
              disposition: disposition
  end

  def disposition
    content_disposition('attachment', filename('skillset', nil, 'csv'))
  end
end
