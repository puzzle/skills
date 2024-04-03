# frozen_string_literal: true

module SelectHelper
  def select_when_availabale(obj)
    selected = obj ? obj.id : ''
    prompt = obj ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end

  def add_default_option(collection, option = {})
    collection.unshift([option[:text], option[:value], option])
  end
end
