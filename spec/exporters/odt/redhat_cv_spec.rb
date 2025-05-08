require 'rails_helper'

describe Odt::RedhatCv do
  fixtures :people

  it 'calls all insert methods on the CV during export' do
    cv = Odt::Cv.new(people(:bob), { 'anon' => 'false' })
    redhat_cv = Odt::RedhatCv.new(cv)
    report = instance_double('ODFReport::Report')

    allow(ODFReport::Report).to receive(:new).and_yield(report)

    %i[
        insert_initials
        insert_languages
        insert_personalien
        insert_general_sections
        insert_advanced_trainings
        insert_activities
        insert_competence_notes_string
      ].each do |method|
      if method == :insert_languages
        expect(cv).to receive(method).with(report, 'EN')
      else
        expect(cv).to receive(method).with(report)
      end
    end

    redhat_cv.export
  end
end