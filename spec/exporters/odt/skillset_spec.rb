require 'rails_helper'

describe Odt::Skillset do
  fixtures :skills

  context 'export' do
    it 'can export' do
      Odt::Skillset.new(skills).export
    end
  end

  context 'fomatting' do
    it 'formats default_set' do
      default_set = Odt::Skillset.new(skills).send(:formatted_default_set, true)
      expect(default_set).to eq('JA')

      default_set = Odt::Skillset.new(skills).send(:formatted_default_set, false)
      expect(default_set).to eq('NEIN')

      default_set = Odt::Skillset.new(skills).send(:formatted_default_set, nil)
      expect(default_set).to eq('NEU')
    end

  end
end
