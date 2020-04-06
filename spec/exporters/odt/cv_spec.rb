require 'rails_helper'

describe Odt::Cv do
  fixtures :people

  context 'export' do
    it 'can export without an image' do
      person = people(:bob)
      person.remove_picture
      expect(person.picture.file).to be_nil
      Odt::Cv.new(person, 'false').export
    end

    it 'can export without competence_notes' do
      person = people(:bob)
      person.competence_notes = nil
      Odt::Cv.new(person, 'false').export
    end
  end

  context 'fomatting' do
    it 'translates nationalities' do
      nationalities = Odt::Cv.new(people(:bob), 'false').send(:nationalities)
      expect(nationalities).to eq('Schweiz, Schweden')

      nationalities = Odt::Cv.new(people(:alice), 'false').send(:nationalities)
      expect(nationalities).to eq('Australien')
    end

    it 'formats competence notes' do
      notes = Odt::Cv.new(people(:bob)).send(:competence_notes_list)[:competence]
      expect(notes).to eq('Java\n Ruby')
    end
	
  end
end
