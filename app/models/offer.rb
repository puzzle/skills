# == Schema Information
#
# Table name: offers
#
#  id         :bigint(8)        not null, primary key
#  category   :string
#  offer      :text             default([]), is an Array
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Offer < ApplicationRecord

  # after_create :update_associations_updatet_at
  # after_update :update_associations_updatet_at
  # after_destroy :update_associations_updatet_at

  # The touch had to be removed because it caused deadlocks on travis
  # belongs_to :company, touch: true
  belongs_to :company

  validates :category, presence: true
  validates :category, length: { maximum: 100 }

  private

  # This hook is being commented because it caused deadlocks on travis and is not used currently
  # def update_associations_updatet_at
  #   timestamp = Time.zone.now
  #   company.update!(associations_updatet_at: timestamp)
  # end

end
