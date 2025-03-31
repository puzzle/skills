class UnifiedSkillsController < CrudController
  self.permitted_attrs = [:old_skill_id1, :old_skill_id2, { skill:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  # rubocop:disable Metrics
  def create
    ActiveRecord::Base.transaction do
      params.permit!
      validate!

      new_skill = Skill.create!(params.fetch(:skill).merge(default_set: false))
      old_skill1 = Skill.find(old_skill_id1)
      old_skill2 = Skill.find(old_skill_id2)
      UnifiedSkill.create!(skill1_attrs: old_skill1.attributes, skill2_attrs: old_skill2.attributes,
                           unified_skill_attrs: new_skill.attributes)
      PeopleSkill.where(skill_id: [old_skill1.id, old_skill2.id]).update!(skill_id: new_skill.id)
      old_skill1.delete
      old_skill2.delete

      new_skill
    end
  end
  # rubocop:enable Metrics

  private

  def old_skill_id1
    params.fetch(:old_skill_id1)
  end

  def old_skill_id2
    params.fetch(:old_skill_id2)
  end

  def validate!
    return true if PeopleSkill
                   .where(skill_id: [old_skill_id1, old_skill_id2])
                   .group(:person_id)
                   .having('COUNT(skill_id) = 2')
                   .none?

    raise 'Merging these skills is not allowed since someone has rated both of them'
  end
end
