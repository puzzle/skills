# frozen_string_literal: true

module ThemeHelper
  THEME_PREFS = %w[auto light dark].freeze

  # The user's stored theme preference ("auto", "light" or "dark").
  # Defaults to "auto" (follow the operating system) when no/invalid cookie is set.
  def theme_cookie_pref
    cookies[:theme].in?(THEME_PREFS) ? cookies[:theme] : 'auto'
  end

  # The theme actually applied via the <html data-bs-theme> attribute on the
  # server-rendered page. The system preference is only known client-side, so
  # "auto" falls back to "light" here; the inline head script upgrades it to the
  # real system value before paint.
  def theme_preference
    theme_cookie_pref == 'dark' ? 'dark' : 'light'
  end
end
