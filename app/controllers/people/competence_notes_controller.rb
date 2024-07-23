# frozen_string_literal: true

class People::CompetenceNotesController < CrudController

  helper_method :computed_size

  def self.model_class
    Person
  end

  def computed_size
    [@person.competence_notes&.lines&.count, 10].compact.max
  end
end
