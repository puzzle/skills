# frozen_string_literal: true

module DateHelper
  def translated_months
    I18n.t('date.month_names').map { |m| m || '' }
  end
end
