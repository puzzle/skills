class UnifiedSkill < ApplicationRecord
  serialize :skill1_attrs, type: Hash, coder: JSON
  serialize :skill2_attrs, type: Hash, coder: JSON
  serialize :unified_skill_attrs, type: Hash, coder: JSON
end
