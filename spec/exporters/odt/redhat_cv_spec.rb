require 'rails_helper'

describe Odt::RedhatCv do

  it 'initializes with a CV object' do
    cv = double('cv')
    redhat_cv = Odt::RedhatCv.new(cv)
    expect(redhat_cv).to be_a(Odt::RedhatCv)
  end

  it 'calls all insert methods on the CV during export' do
    cv = double('cv')
    report = double('report')
    allow(ODFReport::Report).to receive(:new).and_yield(report)

    expect(cv).to receive(:insert_initials).with(report)
    expect(cv).to receive(:insert_personalien).with(report)
    expect(cv).to receive(:insert_general_sections).with(report)
    expect(cv).to receive(:insert_advanced_trainings).with(report)
    expect(cv).to receive(:insert_projects).with(report)
    expect(cv).to receive(:insert_competence_notes_string).with(report)

    redhat_cv = Odt::RedhatCv.new(cv)
    redhat_cv.export
  end
end