# frozen_string_literal: true

class LanguageSkillsController < PersonRelationsController
  self.permitted_attrs = %i[language level certificate person_id]
end
