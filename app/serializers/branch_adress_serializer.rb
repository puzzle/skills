# frozen_string_literal: true

class BranchAdressSerializer < ApplicationSerializer
  attributes :id, :short_name, :adress_information, :country, :default_branch_adress
end
