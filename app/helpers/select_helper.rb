# frozen_string_literal: true

module SelectHelper
  def select_when_availabale(obj)
    selected = obj ? obj.id : ''
    prompt = obj ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end

  def months_with_nil
    month_list = months.compact.each_with_index.map { |month, index| [month, index + 1] }
    add_default_option(month_list, { text: '-' })
  end

  def last_100_years
    (100.years.ago.year..Time.zone.today.year).to_a
  end

  def add_default_option(collection, option = {})
    collection.unshift([option[:text], option[:value], option])
  end
end
