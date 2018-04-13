# == Schema Information
#
# Table name: offers
#
#  id                    :integer          not null, primary key
#  category              :string
#  offer                 :array
#  company_id            :integer

class Offer < ApplicationRecord
  belongs_to :company
end
