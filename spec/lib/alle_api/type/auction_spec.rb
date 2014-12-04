# encoding: utf-8
require 'spec_helper'
require 'support/allegro_auction_macros'
require 'virtus-rspec'

describe AlleApi::Type::Auction do
  extend AlleApiAuctionMacros
  include Virtus::Matchers

  it { should respond_to :valid? }

  def self.expect_attribute_casted_to(attr, expected_primitive)
    actual = AlleApi::Type::Auction.attribute_set[attr].options[:primitive]
    actual.should == expected_primitive
  end

  describe 'attribute types' do
    %w(amount
       category_id
       country_id
       delivery_methods
       duration
       free_delivery_methods
       payment_methods
       region
       type
       covers_delivery_costs
       condition).each do |attr|

      expect_attribute_casted_to attr, Integer
    end

    %w(economic_letter_price
       economic_package_price
       buy_now_price
       priority_letter_price
       priority_package_price).each do |attr|

      expect_attribute_casted_to attr, Float
    end

    %w(description place title zip_code).each do |attr|
      expect_attribute_casted_to attr, String
    end

    expect_attribute_casted_to :starts_at, DateTime
  end

  it 'default values' do
    auction = AlleApi::Type::Auction.new

    auction.amount.should == 1
    auction.buy_now_price.should == 0.0
    auction.category_id.should be_nil
    auction.duration.should == AlleApi::Type::Auction::DURATION_30
    auction.type.should == AlleApi::Type::Auction::TYPE_SHOP
    auction.condition.should == AlleApi::Type::Auction::CONDITION_USED

    auction.covers_delivery_costs.should == AlleApi::Type::Auction::BUYER
    auction.free_delivery_methods.should == 1
    auction.delivery_methods.should == 1 + 2 + 4 + 8
    auction.payment_methods.should == 1

    auction.economic_letter_price.should be_nil
    auction.priority_letter_price.should be_nil
    auction.economic_package_price.should be_nil
    auction.priority_package_price.should be_nil

    auction.region.should == 6
    auction.description.should be_nil
    auction.place.should == 'Kraków'
    auction.title.should be_nil
    auction.zip_code.should == '31-610'
  end

  describe '#to_fields_array' do
    subject { auction.to_fields_array }
    let(:category) { create :category, :with_cached_condition_field }
    let(:condition_fid) { category.fid_for_condition }
    let(:auction)    {
      AlleApi::Type::Auction.new({
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
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:category_id,
                                                                auction[:category_id])
    end

    it "includes hash for :country_id" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:country_id,
                                                               auction[:country_id])
    end

    it "includes hash for :description" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:description,
                                                               auction[:description])
    end

    it "includes hash for :buy_now_price" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:buy_now_price,
                                                               auction[:buy_now_price])
    end

    it "includes hash for :economic_letter_price" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:economic_letter_price,
                                                               auction[:economic_letter_price])
    end

    it "includes hash for :economic_package_price" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:economic_package_price,
                                                               auction[:economic_package_price])
    end

    it "includes hash for :priority_letter_price" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:priority_letter_price,
                                                               auction[:priority_letter_price])
    end

    it "includes hash for :priority_package_price" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:priority_package_price,
                                                               auction[:priority_package_price])
    end

    it "includes hash for :place" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:place,
                                                               auction[:place])
    end

    it "includes hash for :title" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:title,
                                                               auction[:title])
    end

    it "includes hash for :zip_code" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:zip_code,
                                                               auction[:zip_code])
    end

    it "includes hash for attribute :covers_delivery_costs" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:covers_delivery_costs,
                                                                auction[:covers_delivery_costs])
    end

    it "includes hash for attribute :starts_at" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:starts_at,
                                                                auction[:starts_at])
    end

    it "includes hash for attribute :amount" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:amount,
                                                                auction[:amount])
    end

    it "includes hash for attribute :delivery_methods" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:delivery_methods,
                                                                auction[:delivery_methods])
    end

    it "includes hash for attribute :duration" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:duration,
                                                                auction[:duration])
    end

    it "includes hash for attribute :free_delivery_methods" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:free_delivery_methods,
                                                                auction[:free_delivery_methods])
    end

    it "includes hash for attribute :delivery_methods" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:delivery_methods,
                                                                auction[:delivery_methods])
    end

    it "includes hash for attribute :payment_methods" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:payment_methods,
                                                                auction[:payment_methods])
    end

    it "includes hash for attribute :region" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:region,
                                                                auction[:region])
    end

    it "includes hash for attribute :type" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:type,
                                                                auction[:type])
    end

    it "includes hash for attribute :condition" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:condition,
                                                                auction[:condition],
                                                                auction[:category_id])
    end

    it "includes hash for attribute :payment_methods" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:payment_methods,
                                                                auction[:payment_methods])
    end

    it "includes hash for attribute :region" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:region,
                                                                auction[:region])
    end

    it "includes hash for attribute :image_1_string" do
      subject.should include AlleApi::Type::Auction.attribute_to_hash(:image_1_string,
                                                                auction[:image_1_string])
    end

  end


  describe '.attribute_to_hash' do
    subject { AlleApi::Type::Auction.attribute_to_hash(attribute, value) }

    let(:attribute) { :some_attribute }
    let(:value)     { 'some value' }

    context 'when attribute is a Fixnum' do
      let(:attribute) { :category_id }
      let(:value) { 1 }

      it_has_proper_fid
      it_has_value_set_under_key :fvalueInt
    end

    context 'when attribute is a Float' do
      let(:attribute) { :price }
      let(:value) { 2.35 }

      it_has_proper_fid
      it_has_value_set_under_key :fvalueFloat
    end

    context 'when attribute is a String' do
      let(:attribute) { :title }
      let(:value) { 'title' }

      it_has_proper_fid
      it_has_value_set_under_key :fvalueString
    end

    context 'when attribute is a ActiveSupport::SafeBuffer' do
      let(:attribute) { :title }
      let(:value) { ActiveSupport::SafeBuffer.new 'title' }

      it_has_proper_fid
      it_has_value_set_under_key :fvalueString
    end

    context 'when attribute is a DateTime' do
      let(:attribute) { :starts_at }
      let(:value) { DateTime.parse('2011-11-11') }

      it_has_proper_fid
      it 'has value converted #to_i under key fvalueDatetime' do
        subject[:fvalueDatetime].should == value.to_i
      end
    end

    context 'when attribute is a :condition' do
      let(:attribute) { :condition }
      let(:category) { create :category }
      let(:value) { AlleApi::Type::Auction::CONDITION_USED }
      let(:expected_condition_fid) { 23 }
      subject { AlleApi::Type::Auction.attribute_to_hash(attribute, value, category.id) }
      before do
        AlleApi::Type::Auction.expects(:fid_for_condition).with(category.id).returns(expected_condition_fid)
      end

      it 'has fid equal to .fid_for_condition for specific category_id' do
        subject[:fid].should == expected_condition_fid
      end
      it_has_value_set_under_key :fvalueInt
    end

    context 'when attribute is a :image_1_string' do
      let(:attribute) { :image_1_string }

      context "and it has value" do
        let(:value) { 'base64string' }

        it_has_proper_fid
        it_has_default_values_for_all_fvalues_except :fvalueImage
        it_has_value_set_under_key :fvalueImage
      end

      context "and it is nil" do
        let(:value) { nil }

        it_has_proper_fid
        it_has_default_values_for_all_fvalues_except :fvalueImage

        it 'has default value for fvalueImage' do
          subject[:fvalueImage].should == " "
        end
      end
    end
  end


  describe '.fid_for_attribute' do
    def fid_for(attribute); AlleApi::Type::Auction.fid_for_attribute(attribute.to_sym); end

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

      AlleApi::Type::Auction.
        expects(:fid_for_condition).
        with(category_id).
        returns(condition_fid)

      fid = AlleApi::Type::Auction.fid_for_attribute(:condition, category_id)

      fid.should == condition_fid
    end
  end

  describe '.fid_for_condition' do
    let(:category) { create :category }

    it 'returns category#fid_for_condition for specified category_id' do
      AlleApi::Category.any_instance.stubs(fid_for_condition: 23)

      AlleApi::Type::Auction.fid_for_condition(category.id).should == 23
    end
  end

end
