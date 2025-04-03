require 'rails_helper'

describe Odt::Cv do
  fixtures :people

  before { allow_any_instance_of(Odt::Cv).to receive(:location).and_return(branch_adresses(:bern)) }

  context 'export' do
    it 'can export without an image' do
      person = people(:bob)
      person.remove_picture
      expect(person.picture.file).to be_nil
      Odt::Cv.new(person, { 'anon' => 'false' }).export
    end

    it 'can export without competence_notes' do
      person = people(:bob)
      person.competence_notes = nil
      Odt::Cv.new(person, { 'anon' => 'false' }).export
    end

    it 'every tables values should be null if all educations, advanced_trainings, member_notes, projects and activities of the person have attr display_in_cv false' do
      person = people(:maximillian)
      report = Odt::Cv.new(person, { 'anon' => 'false' }).export
      report.as_json["tables"].each do |table|
        expect(table["data_source"]["value"]).to be_empty
      end
    end
    it 'every tables values should not be null if all educations, advanced_trainings, member_notes, projects and activities of the person have attr display_in_cv true' do
      person = people(:longmax)
      report = Odt::Cv.new(person, { 'anon' => 'false' }).export
      report.as_json["tables"].each do |table|
        expect(table["data_source"]["value"]).to_not be_empty
      end
    end
  end

  context 'fomatting' do
    it 'translates nationalities' do
      nationalities = Odt::Cv.new(people(:bob), { 'anon' => 'false' }).send(:nationalities)
      expect(nationalities).to eq('Schweiz, Schweden')

      nationalities = Odt::Cv.new(people(:alice), { 'anon' => 'false' }).send(:nationalities)
      expect(nationalities).to eq('Australien')
    end

    it 'get one skill hash when filter on level 3' do
      skills = Odt::Cv.new(people(:bob), { 'skillsByLevel' => 'true' }).send(:skills_by_level_value, 3)

      expect(skills).to eq([{ :category => "Software-Engineering",
                              :competence => "Kompetenzen des Levels Professional: \r\n- Rails \r\n" }])
    end

    it 'get empty skill hash when filter on level 5' do
      skills = Odt::Cv.new(people(:bob), { 'skillsByLevel' => 'true' }).send(:skills_by_level_value, 5)

      expect(skills).to eq([])
    end

    it 'get PeopleSkill by level 2' do
      skills = Odt::Cv.new(people(:bob), { 'skillsByLevel' => 'true' }).send(:skills_by_level, 2)
      people_skill = PeopleSkill.find 996949822
      expect(skills).to eq([people_skill])
    end

    it 'get no PeopleSkill by level 5' do
      skills = Odt::Cv.new(people(:bob), { 'skillsByLevel' => 'true' }).send(:skills_by_level, 5)
      expect(skills).to eq([])
    end

    it 'formats competence notes' do
      notes = Odt::Cv.new(people(:bob), { 'anon' => 'false' }).send(:competence_notes_list)[:competence]
      expect(notes).to eq("Java\nRuby")
    end

  end
end
