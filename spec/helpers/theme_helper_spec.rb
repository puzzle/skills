require 'rails_helper'

describe ThemeHelper, type: :helper do
  describe '#theme_cookie_pref' do
    %w[auto light dark].each do |pref|
      it "returns the stored '#{pref}' preference" do
        allow(helper).to receive(:cookies).and_return(theme: pref)
        expect(helper.theme_cookie_pref).to eq(pref)
      end
    end

    it 'falls back to auto when no cookie is set' do
      allow(helper).to receive(:cookies).and_return({})
      expect(helper.theme_cookie_pref).to eq('auto')
    end

    it 'falls back to auto for an unknown value' do
      allow(helper).to receive(:cookies).and_return(theme: 'rainbow')
      expect(helper.theme_cookie_pref).to eq('auto')
    end
  end

  describe '#theme_preference' do
    it 'maps the dark preference to the dark attribute' do
      allow(helper).to receive(:cookies).and_return(theme: 'dark')
      expect(helper.theme_preference).to eq('dark')
    end

    # The system preference is only known client-side, so "auto" and "light"
    # both render as "light" on the server; the inline head script upgrades it.
    %w[auto light].each do |pref|
      it "renders the '#{pref}' preference as light on the server" do
        allow(helper).to receive(:cookies).and_return(theme: pref)
        expect(helper.theme_preference).to eq('light')
      end
    end

    it 'renders light when no cookie is set' do
      allow(helper).to receive(:cookies).and_return({})
      expect(helper.theme_preference).to eq('light')
    end
  end
end
