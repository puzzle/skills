class UnifiedSkillsController < CrudController
  self.permitted_attrs = [skill_1_id, skill_2_id, { skill:
                              [:id, :title, :radar, :portfolio, :default_set, :category_id] }]
  def create
    ActiveRecord::Base.transaction do
      params.permit!
      unified_skill = Skill.new(params[:skill].merge(default_set: false))
    end
  end
end
