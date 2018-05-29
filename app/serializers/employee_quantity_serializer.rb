class EmployeeQuantitySerializer < ApplicationSerializer
  attributes :id, :category, :quantity
  belongs_to :company, serializer: CompanyInPersonSerializer
end
