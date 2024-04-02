# frozen_string_literal: true

module SelectHelper
  def select_when_availabale(obj)
    selected = obj ? obj.id : ''
    prompt = obj ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end

  def months_with_nil
    months = translated_months.compact_blank.each_with_index.map do |month, index|
      [month, index + 1]
    end
    months.unshift(['-', nil])
    months
  end

  def last_100_years_disabled_hidden_nil
    years = (100.years.ago.year..Time.zone.today.year).to_a
    years.unshift(['', { value: nil, hidden: true }])
    years
  end
end
