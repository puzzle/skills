# frozen_string_literal: true

module SelectHelper
  def generate_select_options_with_default(person)
    selected = person ? person.id : ''
    prompt = person ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end
end
