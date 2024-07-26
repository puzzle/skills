module UtilitiesHelpers
  def t(string, options={})
    I18n.t(string, **options)
  end
end
