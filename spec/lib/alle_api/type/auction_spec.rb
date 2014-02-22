# encoding: utf-8
require 'spec_helper'
require 'support/allegro_auction_macros'
require 'support/active_attr_macros'
require 'virtus-rspec'

describe AlleApi::Type::Auction do
  extend ActiveAttrHelpers
  extend AlleApiAuctionMacros
  include Virtus::Matchers

  it { should respond_to :valid? }

  describe 'attributes' do
    it_has_integer_attribute :amount
    it_has_integer_attribute :category_id
    it_has_integer_attribute :country_id
    it_has_integer_attribute :delivery_methods
    it_has_integer_attribute :duration
    it_has_integer_attribute :free_delivery_methods
    it_has_integer_attribute :payment_methods
    it_has_integer_attribute :region
    it_has_integer_attribute :type
    it_has_integer_attribute :condition

    it_has_float_attribute :economic_letter_price
    it_has_float_attribute :economic_package_price
    it_has_float_attribute :price
    it_has_float_attribute :buy_now_price
    it_has_float_attribute :priority_letter_price
    it_has_float_attribute :priority_package_price

    it_has_integer_attribute :covers_delivery_costs

    it_has_datetime_attribute :starts_at

    it_has_string_attribute :description
    it_has_string_attribute :place
    it_has_string_attribute :title
    it_has_string_attribute :zip_code
  end

  describe 'default values' do
    its(:amount)                  { should == 1 }
    its(:price)                   { should == 0.0 }
    its(:buy_now_price)           { should == 0.0 }
    its(:category_id)             { should be_nil }
    its(:duration)                { should == described_class::DURATION_30 }
    its(:type)                    { should == described_class::TYPE_SHOP }
    its(:condition)               { should == described_class::CONDITION_USED }

    its(:covers_delivery_costs)   { should == described_class::BUYER }
    its(:free_delivery_methods)   { should == 1 }
    its(:delivery_methods)        { should == 1 + 2 + 4 + 8 }
    its(:payment_methods)         { should == 1 }

    its(:economic_letter_price)   { should be_nil }
    its(:priority_letter_price)   { should be_nil }
    its(:economic_package_price)  { should be_nil }
    its(:priority_package_price)  { should be_nil }

    its(:region)                  { should == 6 }
    its(:description)             { should be_nil }
    its(:place)                   { should == 'Kraków' }
    its(:title)                   { should be_nil }
    its(:zip_code)                { should == '31-610' }
  end


  describe '#to_fields_array' do
    subject { auction.to_fields_array }
    let(:category) { create :category, :with_cached_condition_field }
    let(:condition_fid) { category.fid_for_condition }
    let(:auction)    {
      described_class.new({
        price: 2.35,
        buy_now_price: 5.32,
        category_id: category.id,
        economic_letter_price: 1.11,
        priority_letter_price: 2.22,
        economic_package_price: 3.33,
        priority_package_price: 4.44,
        description: 'text',
        place: 'somewhere',
        title: 'buy me',
        zip_code: '23-555',
      })
    }
    let(:values) { auction.attributes }

    it 'contains proper number of elements' do
      subject.size.should == values.size
    end

    it 'includes hash for :category_id' do
      subject.should include described_class.attribute_to_hash(:category_id,
                                                                auction[:category_id])
    end

    it "includes hash for :country_id" do
      subject.should include described_class.attribute_to_hash(:country_id,
                                                               auction[:country_id])
    end

    it "includes hash for :description" do
      subject.should include described_class.attribute_to_hash(:description,
                                                               auction[:description])
    end

    it "includes hash for :price" do
      subject.should include described_class.attribute_to_hash(:price,
                                                               auction[:price])
    end

    it "includes hash for :buy_now_price" do
      subject.should include described_class.attribute_to_hash(:buy_now_price,
                                                               auction[:buy_now_price])
    end

    it "includes hash for :economic_letter_price" do
      subject.should include described_class.attribute_to_hash(:economic_letter_price,
                                                               auction[:economic_letter_price])
    end

    it "includes hash for :economic_package_price" do
      subject.should include described_class.attribute_to_hash(:economic_package_price,
                                                               auction[:economic_package_price])
    end

    it "includes hash for :priority_letter_price" do
      subject.should include described_class.attribute_to_hash(:priority_letter_price,
                                                               auction[:priority_letter_price])
    end

    it "includes hash for :priority_package_price" do
      subject.should include described_class.attribute_to_hash(:priority_package_price,
                                                               auction[:priority_package_price])
    end

    it "includes hash for :place" do
      subject.should include described_class.attribute_to_hash(:place,
                                                               auction[:place])
    end

    it "includes hash for :title" do
      subject.should include described_class.attribute_to_hash(:title,
                                                               auction[:title])
    end

    it "includes hash for :zip_code" do
      subject.should include described_class.attribute_to_hash(:zip_code,
                                                               auction[:zip_code])
    end

    it "includes hash for attribute :covers_delivery_costs" do
      subject.should include described_class.attribute_to_hash(:covers_delivery_costs,
                                                                auction[:covers_delivery_costs])
    end

    it "includes hash for attribute :starts_at" do
      subject.should include described_class.attribute_to_hash(:starts_at,
                                                                auction[:starts_at])
    end

    it "includes hash for attribute :amount" do
      subject.should include described_class.attribute_to_hash(:amount,
                                                                auction[:amount])
    end

    it "includes hash for attribute :delivery_methods" do
      subject.should include described_class.attribute_to_hash(:delivery_methods,
                                                                auction[:delivery_methods])
    end

    it "includes hash for attribute :duration" do
      subject.should include described_class.attribute_to_hash(:duration,
                                                                auction[:duration])
    end

    it "includes hash for attribute :free_delivery_methods" do
      subject.should include described_class.attribute_to_hash(:free_delivery_methods,
                                                                auction[:free_delivery_methods])
    end

    it "includes hash for attribute :delivery_methods" do
      subject.should include described_class.attribute_to_hash(:delivery_methods,
                                                                auction[:delivery_methods])
    end

    it "includes hash for attribute :payment_methods" do
      subject.should include described_class.attribute_to_hash(:payment_methods,
                                                                auction[:payment_methods])
    end

    it "includes hash for attribute :region" do
      subject.should include described_class.attribute_to_hash(:region,
                                                                auction[:region])
    end

    it "includes hash for attribute :type" do
      subject.should include described_class.attribute_to_hash(:type,
                                                                auction[:type])
    end

    it "includes hash for attribute :condition" do
      subject.should include described_class.attribute_to_hash(:condition,
                                                                auction[:condition],
                                                                auction[:category_id])
    end

    it "includes hash for attribute :payment_methods" do
      subject.should include described_class.attribute_to_hash(:payment_methods,
                                                                auction[:payment_methods])
    end

    it "includes hash for attribute :region" do
      subject.should include described_class.attribute_to_hash(:region,
                                                                auction[:region])
    end

  end


  describe '.attribute_to_hash' do
    subject { described_class.attribute_to_hash(attribute, value) }

    let(:attribute) { :some_attribute }
    let(:value)     { 'some value' }

    context 'when attribute is a Fixnum' do
      let(:attribute) { :category_id }
      let(:value) { 1 }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-int'
      it_has_value_set_under_key 'fvalue-int'
    end

    context 'when attribute is a Float' do
      let(:attribute) { :price }
      let(:value) { 2.35 }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-float'
      it_has_value_set_under_key 'fvalue-float'
    end

    context 'when attribute is a String' do
      let(:attribute) { :title }
      let(:value) { 'title' }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-string'
      it_has_value_set_under_key 'fvalue-string'
    end

    context 'when attribute is a ActiveSupport::SafeBuffer' do
      let(:attribute) { :title }
      let(:value) { ActiveSupport::SafeBuffer.new 'title' }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-string'
      it_has_value_set_under_key 'fvalue-string'
    end

    context 'when attribute is a DateTime' do
      let(:attribute) { :starts_at }
      let(:value) { DateTime.parse('2011-11-11') }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-datetime'
      it 'has value converted #to_i under key fvalue-datetime' do
        subject['fvalue-datetime'].should == value.to_i
      end
    end

    context 'when attribute is a TrueClass' do
      let(:attribute) { :covers_delivery_costs }
      let(:value) { true }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-boolean'
      it_has_value_set_under_key 'fvalue-boolean'
    end

    context 'when attribute is a FalseClass' do
      let(:attribute) { :covers_delivery_costs }
      let(:value) { false }

      it_has_proper_fid
      it_has_default_values_for_all_fvalues_except 'fvalue-boolean'
      it_has_value_set_under_key 'fvalue-boolean'
    end

    context 'when attribute is a :condition' do
      let(:attribute) { :condition }
      let(:category) { create :category }
      let(:value) { described_class::CONDITION_USED }
      let(:expected_condition_fid) { 23 }
      subject { described_class.attribute_to_hash(attribute, value, category.id) }
      before do
        described_class.expects(:fid_for_condition).with(category.id).returns(expected_condition_fid)
      end

      it 'has fid equal to .fid_for_condition for specific category_id' do
        subject['fid'].should == expected_condition_fid
      end
      it_has_default_values_for_all_fvalues_except 'fvalue-int'
      it_has_value_set_under_key 'fvalue-int'
    end
  end


  describe '.fid_for_attribute' do
    def fid_for(attribute); described_class.fid_for_attribute(attribute.to_sym); end

    it 'has valid fid for :title' do
      fid_for(:title).should == 1
    end

    it 'has valid fid for :category' do
      fid_for(:category_id).should == 2
    end

    it 'has valid fid for :starts_at' do
      fid_for(:starts_at).should == 3
    end

    it 'has valid fid for :duration' do
      fid_for(:duration).should == 4
    end

    it 'has valid fid for :amount' do
      fid_for(:amount).should == 5
    end

    it 'has valid fid for :price' do
      fid_for(:price).should == 7
    end

    it 'has valid fid for :buy_now_price' do
      fid_for(:buy_now_price).should == 8
    end

    it 'has valid fid for :country_id' do
      fid_for(:country_id).should == 9
    end

    it 'has valid fid for :region' do
      fid_for(:region).should == 10
    end

    it 'has valid fid for :place' do
      fid_for(:place).should == 11
    end

    it 'has valid fid for :covers_delivery_costs' do
      fid_for(:covers_delivery_costs).should == 12
    end

    it 'has valid fid for :delivery_methods' do
      fid_for(:delivery_methods).should == 13
    end

    it 'has valid fid for :free_delivery_methods' do
      fid_for(:free_delivery_methods).should == 35
    end

    it 'has valid fid for :payment_methods' do
      fid_for(:payment_methods).should == 14
    end

    it 'has valid fid for :description' do
      fid_for(:description).should == 24
    end

    it 'has valid fid for :zip_code' do
      fid_for(:zip_code).should == 32
    end

    it 'has valid fid for :economic_package_price' do
      fid_for(:economic_package_price).should == 36
    end

    it 'has valid fid for :priority_package_price' do
      fid_for(:priority_package_price).should == 38
    end

    it 'has valid fid for :economic_letter_price' do
      fid_for(:economic_letter_price).should == 41
    end

    it 'has valid fid for :priority_letter_price' do
      fid_for(:priority_letter_price).should == 43
    end

    it 'has valid fid for :type' do
      fid_for(:type).should == 29
    end

    it 'has valid fid for :condition for given category' do
      condition_fid = 123
      category_id = 321

      described_class.
        expects(:fid_for_condition).
        with(category_id).
        returns(condition_fid)

      fid = described_class.fid_for_attribute(:condition, category_id)

      fid.should == condition_fid
    end
  end

  describe '.fid_for_condition' do
    let(:category) { create :category }

    it 'returns category#fid_for_condition for specified category_id' do
      AlleApi::Category.any_instance.stubs(fid_for_condition: 23)

      described_class.fid_for_condition(category.id).should == 23
    end
  end

end
