require 'spec_helper'
require 'shared/wrapper'

describe AlleApi::Wrapper::ShipmentAddress do
  extend WrapperMacros

  converts_nil_hash_to_nil_for :full_name
  converts_nil_hash_to_nil_for :company_name
  converts_nil_hash_to_nil_for :address_1
  converts_nil_hash_to_nil_for :city
  converts_nil_hash_to_nil_for :zipcode
  converts_nil_hash_to_nil_for :phone_number

  describe "#country" do
    it 'gets country name from AlleApi::Countries' do
      subject.country_id = 7
      expect(subject.country).to_not be_nil
      expect(subject.country).to eq AlleApi::Countries[7]

      subject.country_id = 20
      expect(subject.country).to_not be_nil
      expect(subject.country).to eq AlleApi::Countries[20]
    end
  end
end
