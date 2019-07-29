# frozen_string_literal: true

# == Schema Information
#
# Table name: expertise_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  discipline :integer          not null
#

class ExpertiseCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :discipline

end
