class DepartmentSkillSnapshot < ApplicationRecord
  belongs_to :department

  serialize :department_skill_levels, type: Hash, coder: JSON
end
