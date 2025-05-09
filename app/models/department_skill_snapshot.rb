class DepartmentSkillSnapshot < ApplicationRecord
  belongs_to :department

  serialize :skills, type: Hash, coder: JSON
end
