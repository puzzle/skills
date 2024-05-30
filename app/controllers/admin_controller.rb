# frozen_string_literal: true

class AdminController < CrudController
  def self.model_class
    AuthUser
  end
end
