# == Schema Information
#
# Table name: person_competences
#
#  id                    :integer          not null, primary key
#  offer                 :array
#  project_id            :integer

class ProjectTechnology < ApplicationRecord

  belongs_to :project

end
