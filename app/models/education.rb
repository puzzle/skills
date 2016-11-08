# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  type       :text
#  updated_at :datetime
#  updated_by :string
#  year_from  :integer
#  year_to    :integer
#  person_id  :integer
#

class Education < ApplicationRecord
  belongs_to :person
end
