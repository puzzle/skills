# == Schema Information
#
# Table name: project_technologies
#
#  id         :bigint(8)        not null, primary key
#  offer      :text             default([]), is an Array
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectTechnology < ApplicationRecord

  belongs_to :project

end
