class Admin::UnifiedSkillsController < CrudController
  self.nesting = :admin

  def self.model_class
    UnifiedSkillForm
  end

  def build_entry
    UnifiedSkillForm.new
  end

  self.permitted_attrs = [:checked_conflicts, :old_skill_id1, :old_skill_id2,
                          { new_skill: [:id, :title, :radar,
                                        :portfolio, :default_set,
                                        :category_id] }]

  before_action :render_unauthorized_not_admin
  before_action :assign_and_validate_entry, only: :create

  def create
    old_skill1 = Skill.find(old_skill_id1)
    old_skill2 = Skill.find(old_skill_id2)

    ActiveRecord::Base.transaction do
      merge_skills(old_skill1, old_skill2)
    end

    flash[:notice] = t('.success', skill1: old_skill1.title, skill2: old_skill2.title)
    redirect_to new_admin_unified_skill_path
  end

  private

  def assign_and_validate_entry
    assign_attributes
    flash.clear

    unless entry.valid?
      return respond_to do |format|
        flash[:alert] = error_messages.presence || flash_message(:failure)
        format.turbo_stream { render 'new', status: :bad_request }
      end
    end

    check_skill_conflicts
  end

  def check_skill_conflicts
    return if true?(entry.checked_conflicts)

    entry.check_conflicts
    respond_to do |format|
      set_flash_for_conflicts
      format.turbo_stream { render 'new', status: :ok }
    end
  end

  def set_flash_for_conflicts
    if entry.conflicts.any?
      flash[:alert] = t('.conflicts_found', names: entry.conflicts.to_sentence,
                                            count: entry.conflicts.count)
    else
      flash[:notice] = t('.no_conflicts_found')
    end
  end

  def merge_skills(old_skill1, old_skill2)
    new_skill = Skill.create!(entry.new_skill)
    update_people_skills(new_skill.id)
    UnifiedSkill.create!(skill1_attrs: old_skill1.attributes, skill2_attrs: old_skill2.attributes,
                         unified_skill_attrs: new_skill.attributes)

    old_skill1.delete
    old_skill2.delete
  end

  def update_people_skills(new_skill_id)
    PeopleSkill.where(skill_id: [old_skill_id1, old_skill_id2])
               .group_by(&:person_id)
               .each_value do |people_skills|

      best_people_skill = people_skills.max_by { |ps| ps.level.to_i }
      other_people_skills = people_skills - [best_people_skill]
      best_people_skill&.update!(skill_id: new_skill_id)
      other_people_skills.each { |ps| ps.delete }
    end
  end

  def old_skill_id1
    entry.old_skill_id1
  end

  def old_skill_id2
    entry.old_skill_id2
  end
end
