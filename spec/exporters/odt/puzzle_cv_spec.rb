require 'rails_helper'

describe Odt::PuzzleCv do
  fixtures :people

  describe '#export' do
    let(:cv) { Odt::Cv.new(people(:bob), { 'anon' => 'false' })}
    let(:puzzle_cv) { Odt::PuzzleCv.new(cv) }

    before do
      allow(cv).to receive(:skill_level_value).and_return(:senior)
      allow(cv).to receive(:skills_by_level_value).with(:senior).and_return(%w[Ruby Rails])
    end

    subject { puzzle_cv.export }

    context 'when country is DE, anon is true, and skills by level included' do
      country = 'DE'
      is_anon = true
      include_level = true

      before do
        allow(cv).to receive(:location).and_return(double(country: country))
        allow(cv).to receive(:anon?).and_return(is_anon)
        allow(cv).to receive(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with correct template name' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template_anon.odt')
        subject
      end
    end

    context 'when country is US, anon is false, and skills by level not included' do
      country = 'US'
      is_anon = false
      include_level = false

      before do
        allow(cv).to receive(:location).and_return(double(country: country))
        allow(cv).to receive(:anon?).and_return(is_anon)
        allow(cv).to receive(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with basic template name' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template.odt')
        subject
      end
    end

    context 'when country is DE, anon is false, and skills by level included' do
      country = 'DE'
      is_anon = false
      include_level = true

      before do
        allow(cv).to receive(:location).and_return(double(country: country))
        allow(cv).to receive(:anon?).and_return(is_anon)
        allow(cv).to receive(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with correct suffixes' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template.odt')
        subject
      end
    end

    context 'when setting skills_by_level_list' do
      country = 'DE'
      is_anon = false
      include_level = false

      before do
        allow(cv).to receive(:location).and_return(double(country: country))
        allow(cv).to receive(:anon?).and_return(is_anon)
        allow(cv).to receive(:include_skills_by_level?).and_return(include_level)
        allow(cv).to receive(:skill_level_value).and_return(:mid)
        allow(cv).to receive(:skills_by_level_value).with(:mid).and_return(%w[SQL Python])
        allow(puzzle_cv).to receive(:new_report)
      end

      it 'sets @skills_by_level_list using skills_by_level_value and skill_level_value' do
        expect(cv).to receive(:skill_level_value).and_return(:mid)
        expect(cv).to receive(:skills_by_level_value).with(:mid).and_return(%w[SQL Python])

        puzzle_cv.export

        expect(cv.instance_variable_get(:@skills_by_level_list)).to eq(%w[SQL Python])
      end
    end

    context 'check functionality of display_in_cv attribute' do

      before { allow_any_instance_of(Odt::Cv).to receive(:location).and_return(branch_adresses(:bern)) }

      it 'every tables values should be null if all educations, advanced_trainings, member_notes, projects and activities of the person have attr display_in_cv false' do
        person = people(:maximillian)
        cv = Odt::Cv.new(person, { 'anon' => 'false' })

        report = Odt::PuzzleCv.new(cv).export
        report.as_json["tables"].each do |table|
          expect(table["data_source"]["value"]).to be_empty
        end
      end

      it 'every tables values should not be null if all educations, advanced_trainings, member_notes, projects and activities of the person have attr display_in_cv true' do
        person = people(:longmax)
        cv = Odt::Cv.new(person, { 'anon' => 'false' })

        report = Odt::PuzzleCv.new(cv).export
        report.as_json["tables"].each do |table|
          next if table["name"] == "LEVEL_COMPETENCES"
          expect(table["data_source"]["value"]).to_not be_empty
        end
      end
    end
  end

  describe '#new_report' do
    let(:cv) { Odt::Cv.new(people(:bob), { 'anon' => 'false' })}
    let(:puzzle_cv) { Odt::PuzzleCv.new(cv) }
    let(:report) { instance_double('ODFReport::Report') }

    before do
      allow(ODFReport::Report).to receive(:new).and_yield(report)
    end

    it 'calls all section insertion methods on the CV' do
      %i[
        insert_general_sections
        insert_languages
        insert_locations
        insert_personalien
        insert_competences
        insert_advanced_trainings
        insert_educations
        insert_activities
        insert_projects
      ].each do |method|
        expect(cv).to receive(method).with(report)
      end

      puzzle_cv.new_report('cv_template.odt')
    end
  end
end
