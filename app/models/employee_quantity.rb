# == Schema Information
#
# Table name: employee_quantities
#
#  id                    :integer          not null, primary key
#  category              :string
#  quantity              :integer
#  company_id            :integer

class EmployeeQuantity < ApplicationRecord
  belongs_to :company
  
  validates :category, :quantity, presence: true
  validates :category, length: { maximum: 100 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
