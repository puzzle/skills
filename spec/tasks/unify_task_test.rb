require 'rails_helper'

class UnifyTaskTest
  describe 'unify' do

    before do
      Rake.application.rake_require 'tasks/unify'
    end

    it "should find correct duplicates" do
      expect {
        Rake::Task["unify"].execute
      }.to output(
                   "Possible duplicates detected: JUnit (id: #{Skill.find_by(title: 'JUnit').id}) matched: cunit (id: #{Skill.find_by(title: 'cunit').id}).\n" +
                   "Possible duplicates detected: WebComponents (id: #{Skill.find_by(title: 'WebComponents').id}) matched: Web Components (id: #{Skill.find_by(title: 'Web Components').id}).\n"
                 ).to_stdout
    end
  end
end