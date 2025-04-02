class Admin::UnifiedSkillsController < CrudController
  self.nesting = :admin

  def self.model_class
    UnifiedSkillForm
  end

  def build_entry
    UnifiedSkillForm.new
  end

  self.permitted_attrs = [:old_skill_id1, :old_skill_id2, { new_skill: [:id, :title, :radar,
                                                                        :portfolio, :default_set,
                                                                        :category_id] }]
  before_action :render_unauthorized_not_admin

  def create
    assign_attributes

    return redirect_on_failure(location: new_admin_unified_skill_path) unless entry.valid?

    ActiveRecord::Base.transaction do
      old_skill1 = Skill.find(old_skill_id1)
      old_skill2 = Skill.find(old_skill_id2)

      merge_skills(old_skill1, old_skill2)
    end
  end

  private

  def merge_skills(old_skill1, old_skill2)
    new_skill = Skill.create!(entry.new_skill)
    PeopleSkill.where(skill_id: [old_skill_id1, old_skill_id2]).update!(skill_id: new_skill.id)
    UnifiedSkill.create!(skill1_attrs: old_skill1.attributes, skill2_attrs: old_skill2.attributes,
                         unified_skill_attrs: new_skill.attributes)

    old_skill1.delete
    old_skill2.delete
  end

  def old_skill_id1
    entry.old_skill_id1
  end

  def old_skill_id2
    entry.old_skill_id2
  end
end
