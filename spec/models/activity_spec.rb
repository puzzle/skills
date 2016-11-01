require 'rails_helper'

describe Activity do
  fixtures :activities

  context 'validations' do
    it 'does not create Activity if from is bigger than to' do
      # TODO
      # activity = activities(:one)
      # activity.year_to = 2016
      # activity.save
      # expect(activity.errors[:year_to].first).to eq('must be higher than year from')
    end
  end
end
