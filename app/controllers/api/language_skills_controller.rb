# frozen_string_literal: true

class Api::LanguageSkillsController < Api::PersonRelationsController
  self.permitted_attrs = %i[language level certificate person_id]
end
