require 'rails_helper'

class UnifyTaskTest
  describe 'unify' do

    before do
      Rake.application.rake_require 'tasks/unify'
    end

    it "should find correct duplicates" do
      expect {
        Rake::Task["unify"].execute
      }.to output("Duplicate of: JUnit id: 677333953 Duplicate: cunit id: 625945042\nDuplicate of: WebComponents id: 1031312693 Duplicate: Web Components id: 157721798\n").to_stdout
    end
  end
end