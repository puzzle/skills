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
    it 'returns just one year if year_from and year_to are the same' do
      activity = Activity.new(year_to: 2000, year_from: 2000)

      formatted_year = Odt::Cv.new(nil).send(:formatted_year, activity)

      expect(formatted_year).to eq(2000)
    end

    it 'returns formatted year_from and year_to if they are not the same' do
      activity = Activity.new(year_from: 2000, year_to: 2010)

      formatted_year = Odt::Cv.new(nil).send(:formatted_year, activity)

      expect(formatted_year).to eq('2000 - 2010')
    end
  end
end
