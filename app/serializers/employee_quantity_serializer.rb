class EmployeeQuantitySerializer < ApplicationSerializer
  attributes :id, :category, :quantity
  has_one :company
end
