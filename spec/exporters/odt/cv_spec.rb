require 'rails_helper'

describe Odt::Cv do
  fixtures :people

  context 'export' do
    it 'can export without an image' do
      person = people(:bob)
      person.remove_picture
      expect(person.picture.file).to be_nil
      Odt::Cv.new(person).export
    end

    it 'can export without competences' do
      person = people(:bob)
      person.competences = nil
      Odt::Cv.new(person).export
    end
  end

  context 'fomatting' do
    it 'returns just one date if finish_at and start_at are the same' do
      activity = Activity.new(start_at: 2000, finish_at: 2000)

      formatted_date = Odt::Cv.new(nil).send(:formatted_date, activity)

      expect(formatted_date).to eq(2000)
    end

    it 'returns formatted finish_at and start_at if they are not the same' do
      activity = Activity.new(finish_at: 2000, start_at: 2010)

      formatted_date = Odt::Cv.new(nil).send(:formatted_date, activity)

      expect(formatted_date).to eq('2000 - 2010')
    end

    it 'translates nationalities' do
      nationalities = Odt::Cv.new(people(:bob)).send(:nationalities)
      expect(nationalities).to eq('Schweiz, Schweden')

      nationalities = Odt::Cv.new(people(:alice)).send(:nationalities)
      expect(nationalities).to eq('Australien')
    end

  end
end
