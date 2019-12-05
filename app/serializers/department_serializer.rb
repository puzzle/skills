# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class DepartmentSerializer < ApplicationSerializer
  attributes :id, :name
end
