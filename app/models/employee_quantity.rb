# == Schema Information
#
# Table name: employee_quantities
#
#  id                    :integer          not null, primary key
#  category              :string
#  quantity              :integer
#  company_id            :integer

class EmployeeQuantity < ApplicationRecord
  
  after_create :update_associations_updatet_at
  after_update :update_associations_updatet_at
  after_destroy :update_associations_updatet_at

  belongs_to :company, touch: true

  validates :category, :quantity, presence: true
  validates :category, length: { maximum: 100 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  private

  def update_associations_updatet_at
  	timestamp = DateTime.now
    self.company.update!(associations_updatet_at: timestamp)
  end

end
