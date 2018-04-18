# == Schema Information
#
# Table name: offers
#
#  id                    :integer          not null, primary key
#  category              :string
#  offer                 :array
#  company_id            :integer

require 'rails_helper'


describe Offer do

    context 'validations' do
      it 'checks whether required attribute values are present' do
        offer = Offer.new
        offer.valid?

        expect(offer.errors[:category].first).to eq('muss ausgefüllt werden')
      end

      it 'should not be more than 100 characters' do
        offer = Offer.new
        offer.category = SecureRandom.hex(150)
        offer.valid?

        expect(offer.errors[:category].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      end
    end
end
