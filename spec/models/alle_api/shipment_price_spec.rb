require 'spec_helper'

describe AlleApi::ShipmentPrice do

  describe '.all_for_weight' do
    it 'collects all prices for given weight' do
      weight = 777
      expected = {}
      described_class::TYPES.each do |type|
        expected[type] = AlleApi::Auction.shipment_price_by_weight(type, weight)
      end
      actual = described_class.all_for_weight(weight)

      expect(expected).to have(described_class::TYPES.length).items
      expect(expected).to eq(actual)
    end
  end
end
