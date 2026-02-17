require 'rails_helper'

describe Odt::Cv do
  fixtures :people

  before { allow_any_instance_of(Odt::Cv).to receive(:location).and_return(branch_adresses(:bern)) }

  let(:person) { double('Person') }
  let(:params) do
    {
      customerCode: 'CUST-123',
      projectCode: 'PROJ-99',
      departmentCode: 'DEPT-ALPHA'
    }
  end

  subject { described_class.new(person, params) }

    it 'can export without an image' do
      person = people(:bob)
      person.remove_picture
      expect(person.picture.file).to be_nil
      Odt::Cv.new(person, { 'anon' => 'false' })
    end

    it 'can export without competence_notes' do
      person = people(:bob)
      person.competence_notes = nil
      Odt::Cv.new(person, { 'anon' => 'false' })
    end

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

    it 'correctly assigns the person object' do
      expect(subject.instance_variable_get(:@person)).to eq(person)
    end

    it 'assigns customer_code from params' do
      expect(subject.instance_variable_get(:@customer_code)).to eq('CUST-123')
    end

    it 'assigns project_code from params' do
      expect(subject.instance_variable_get(:@project_code)).to eq('PROJ-99')
    end

    it 'assigns department_code from params' do
      expect(subject.instance_variable_get(:@department_code)).to eq('DEPT-ALPHA')
    end

  describe 'format language with level correctly' do
    let(:bob) { people(:bob) }
    let(:cv) { Odt::Cv.new(bob, { 'anon' => 'false' }) }
    let(:report) { instance_double('ODFReport::Report') }
    let(:german) { language_skills(:deutsch)}

    it 'should not include language level when it is (Keine)' do
      spanish = language_skills(:spanisch)

      allow(bob).to receive_message_chain(:language_skills, :list).and_return([german, spanish])

      expected_output = "Deutsch (Muttersprache)"

      expect(report).to receive(:add_field).with(:languages, expected_output)

      cv.send(:insert_languages, report, 'DE')
    end

    it 'should include language level when it has a level' do
      english = language_skills(:englisch)

      allow(bob).to receive_message_chain(:language_skills, :list).and_return([german, english])

      expected_output = "Deutsch (Muttersprache)\nEnglisch (B1)"

      expect(report).to receive(:add_field).with(:languages, expected_output)

      cv.send(:insert_languages, report, 'DE')
    end
  end
end
