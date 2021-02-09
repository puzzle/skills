# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  short_name              :string
#  adress_information      :string
#  country                 :strings
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class BranchAdress < ApplicationRecord
end
