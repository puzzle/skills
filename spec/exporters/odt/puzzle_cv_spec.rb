require 'rails_helper'

describe Odt::PuzzleCv do
  describe '#export' do
    let(:cv) { instance_double('Cv') }
    let(:puzzle_cv) { described_class.new(cv) }

    before do
      allow(cv).to receive(:send).with(:skill_level_value).and_return(:senior)
      allow(cv).to receive(:send).with(:skills_by_level_value, :senior).and_return(%w[Ruby Rails])
    end

    subject { puzzle_cv.export }

    context 'when country is DE, anon is true, and skills by level included' do
      let(:country) { 'DE' }
      let(:is_anon) { true }
      let(:include_level) { true }

      before do
        allow(cv).to receive(:send).with(:location).and_return(double(country: country))
        allow(cv).to receive(:send).with(:anon?).and_return(is_anon)
        allow(cv).to receive(:send).with(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with correct template name' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template_de_anon_with_level.odt')
        subject
      end
    end

    context 'when country is US, anon is false, and skills by level not included' do
      let(:country) { 'US' }
      let(:is_anon) { false }
      let(:include_level) { false }

      before do
        allow(cv).to receive(:send).with(:location).and_return(double(country: country))
        allow(cv).to receive(:send).with(:anon?).and_return(is_anon)
        allow(cv).to receive(:send).with(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with basic template name' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template.odt')
        subject
      end
    end

    context 'when country is DE, anon is false, and skills by level included' do
      let(:country) { 'DE' }
      let(:is_anon) { false }
      let(:include_level) { true }

      before do
        allow(cv).to receive(:send).with(:location).and_return(double(country: country))
        allow(cv).to receive(:send).with(:anon?).and_return(is_anon)
        allow(cv).to receive(:send).with(:include_skills_by_level?).and_return(include_level)
      end

      it 'calls new_report with correct suffixes' do
        expect(puzzle_cv).to receive(:new_report).with('cv_template_de_with_level.odt')
        subject
      end
    end

    context 'when setting skills_by_level_list' do
      let(:country) { 'DE' }
      let(:is_anon) { false }
      let(:include_level) { false }

      before do
        allow(cv).to receive(:send).with(:location).and_return(double(country: country))
        allow(cv).to receive(:send).with(:anon?).and_return(is_anon)
        allow(cv).to receive(:send).with(:include_skills_by_level?).and_return(include_level)
        allow(cv).to receive(:send).with(:skill_level_value).and_return(:mid)
        allow(cv).to receive(:send).with(:skills_by_level_value, :mid).and_return(%w[SQL Python])
        allow(puzzle_cv).to receive(:new_report)
      end

      it 'sets @skills_by_level_list using skills_by_level_value and skill_level_value' do
        expect(cv).to receive(:send).with(:skill_level_value).and_return(:mid)
        expect(cv).to receive(:send).with(:skills_by_level_value, :mid).and_return(%w[SQL Python])

        puzzle_cv.export

        expect(cv.instance_variable_get(:@skills_by_level_list)).to eq(%w[SQL Python])
      end
    end
  end

  describe '#new_report' do
    let(:cv) { instance_double('Cv') }
    let(:puzzle_cv) { described_class.new(cv) }
    let(:report) { instance_double('ODFReport::Report') }
    let(:template_name) { 'cv_template.odt' }

    before do
      allow(ODFReport::Report).to receive(:new).and_yield(report)
    end

    it 'calls all section insertion methods on the CV' do
      %i[
        insert_general_sections
        insert_locations
        insert_personalien
        insert_competences
        insert_advanced_trainings
        insert_educations
        insert_activities
        insert_projects
      ].each do |method|
        expect(cv).to receive(:send).with(method, report)
      end

      puzzle_cv.new_report(template_name)
    end
  end
end
