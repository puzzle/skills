# == Schema Information
#
# Table name: employee_quantities
#
#  id         :bigint(8)        not null, primary key
#  category   :string
#  quantity   :integer
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmployeeQuantitySerializer < ApplicationSerializer
  attributes :id, :category, :quantity
  belongs_to :company, serializer: CompanyInPersonSerializer
end
