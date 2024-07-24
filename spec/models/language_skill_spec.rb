# == Schema Information
#
# Table name: language_skills
#
#  id          :bigint(8)        not null, primary key
#  language    :string
#  level       :string
#  certificate :string
#  person_id   :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe LanguageSkill do
  context 'validations' do
    it 'checks presence of language' do
      skill = LanguageSkill.new
      skill.valid?

      expect(skill.errors[:language].first).to eq('muss ausgefüllt werden')
    end

    it 'checks presence of level' do
      skill = LanguageSkill.new
      skill.valid?

      expect(skill.errors[:level].first).to eq('muss ausgefüllt werden')
    end

    it 'only destroy when not an obligatory language' do
      skill = language_skills(:deutsch)
      skill.destroy

      expect(skill.errors[:language].first).to eq('darf nicht gelöscht werden.')
    end
  end
end
