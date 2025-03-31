class UnifiedSkillsController < CrudController
  self.permitted_attrs = [:old_skill_id1, :old_skill_id2, { skill:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  def create
    ActiveRecord::Base.transaction do
      params.permit!
      new_skill = Skill.create!(params.fetch(:skill).merge(default_set: false))
      old_skill1 = Skill.find(params.fetch(:old_skill_id1))
      old_skill2 = Skill.find(params.fetch(:old_skill_id2))
      UnifiedSkill.create!(skill_1_attrs: old_skill1.attributes, skill_2_attrs: old_skill2.attributes, unified_skill_attrs: new_skill.attributes)
      PeopleSkill.where(skill_id: [old_skill1.id, old_skill2.id]).update!(skill_id: new_skill.id)
      old_skill1.delete!
      old_skill2.delete!
    end
  end
end
