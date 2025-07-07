# frozen_string_literal: true

class SkillsController < CrudController
  include ExportController
  before_action :update_category_parent, only: [:update]
  before_action :render_unauthorized_not_admin, except: %i[index show unrated_by_person]

  helper_method :compare_default_set

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  def create
    super(:location => skills_path,
          render_on_failure: 'skills/form_update',
          status: :unprocessable_entity)
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

  def export
    send_data Csv::Skillset.new(fetch_entries).export,
              type: :csv,
              disposition: disposition
  end

  private

  def compare_default_set(value)
    value == params[:defaultSet]
  end

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

  def disposition
    content_disposition('attachment', filename('skillset', nil, 'csv'))
  end

  def entries
    @skills =
      SkillsFilter.new(Skill.all,
                       params[:category],
                       params[:title]&.strip,
                       params[:defaultSet]).scope
  end

  # rubocop:disable Metrics/AbcSize
  def update_category_parent
    current_parent_id = Category.find(params[:skill][:category_id]).parent.id
    new_parent_id = params[:skill].delete(:category_parent).to_i
    if current_parent_id != new_parent_id
      entry.category_id = Category.find(new_parent_id).children.first.id
      params[:skill].delete(:category_id)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
