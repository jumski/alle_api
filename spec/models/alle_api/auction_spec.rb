require 'spec_helper'
require 'shared/auction'
require 'rspec/freezed_time_context'

describe AlleApi::Auction do
  let(:auction) { build_stubbed :auction }

  context "relations" do
    it { should belong_to(:template).class_name('::AlleApi::AuctionTemplate') }
    it { should belong_to(:account) }
    it { should have_many(:all_auctions).class_name('::AlleApi::Auction').
                                              through(:template) }
    it { should have_many :deal_events }
  end

  it { should delegate(:end_publishing!).to(:template) }
  it { should delegate(:disable_publishing!).to(:template) }
  it { should delegate(:enable_publishing!).to(:template) }
  it { should delegate(:finish_current_auction!).to(:template) }
  it { should delegate(:current_auction).to(:template) }

  it_behaves_like 'auction' do
    let(:factory) { :auction }
  end

  it '#inspect' do
    expect(subject.inspect).to eq "<#{subject.state}:#{subject.id}:#{subject.remote_id}>"
  end

  context 'class' do
    describe '.shipment_price_by_weight' do
      let(:shipment_prices) do
        {
          priority_package_price: {
              100 => 5.1,
              500 => 6.1,
              1000 => 7.1 },
        }
      end

      before do
        AlleApi::Auction.stubs(:shipment_prices).returns(shipment_prices)
      end

      def shipment_price_for_weight(weight)
        AlleApi::Auction.shipment_price_by_weight(:priority_package_price, weight)
      end

      it 'returns value for proper weight range' do
        shipment_price_for_weight(0).should === 5.1

        shipment_price_for_weight(60).should === 5.1
        shipment_price_for_weight(100).should === 5.1

        shipment_price_for_weight(250).should === 6.1
        shipment_price_for_weight(500).should === 6.1

        shipment_price_for_weight(750).should === 7.1
        shipment_price_for_weight(1000).should === 7.1

        shipment_price_for_weight(2000).should === 7.1
      end

      it 'returns value for proper weight range if string provided' do
        shipment_price_for_weight('0').should === 5.1

        shipment_price_for_weight('60').should === 5.1
        shipment_price_for_weight('100').should === 5.1

        shipment_price_for_weight('250').should === 6.1
        shipment_price_for_weight('500').should === 6.1

        shipment_price_for_weight('750').should === 7.1
        shipment_price_for_weight('1000').should === 7.1

        shipment_price_for_weight('2000').should === 7.1
      end
    end

    describe '.shipment_prices' do
      let(:hash) { {some: :hash} }

      it 'loads prices from config/shipment_prices.yml' do
        YAML.expects(:load_file).
             with(Rails.root.join('config/shipment_prices.yml')).
             returns(hash)

        AlleApi::Auction.shipment_prices.should == hash.with_indifferent_access
      end
    end
  end

  context 'scopes for states' do
    before do
      @published              = create :auction, state: 'published'
      @queued_for_publication = create :auction, state: 'queued_for_publication'
      @bought_now             = create :auction, state: 'bought_now'
    end

    it '.published gets only published auctions' do
      AlleApi::Auction.published.should == [@published]
    end

    it '.queued_for_publication gets only queued_for_publication auctions' do
      AlleApi::Auction.queued_for_publication.should == [@queued_for_publication]
    end

    it '.bought_now gets only bought_now auctions' do
      AlleApi::Auction.bought_now.should == [@bought_now]
    end
  end

  # recently for ended, published and bought_now states
  states = %w(ended published bought_now).map(&:to_sym)
  states.each do |state|
    describe ".recently for state #{state}" do
      before do
        timestamp = :"#{state}_at"

        @more_recent = create :auction, state, timestamp => (5.days.ago)
        @recent = create :auction, state, timestamp => (7.days.ago + 1.minute)
        @not_recently = create :auction, state, timestamp => (7.days.ago - 1.minute)

        # get some other state from the list
        other_state = (states.dup - [state]).sample
        @in_other_state = create :auction, other_state,
          timestamp => (7.days.ago + 1.minute)
      end
      subject { described_class.send(:recently, state) }

      it { should include @more_recent }
      it { should include @recent }
      it { should_not include @not_recently }
      it { should_not include @in_other_state }

      it 'orders auctions by event timestamp, newest first' do
        expect(subject[0]).to eq(@more_recent)
        expect(subject[1]).to eq(@recent)
      end
    end
  end

  describe '.ending_soon' do
    before do
      @sooner = create :auction, :published, published_at: 29.days.ago
      @soon = create :auction, :published, published_at: 28.days.ago
      @not_soon = create :auction, :published, published_at: 20.days.ago
      @in_other_state = create :auction, :ended, published_at: 28.days.ago
    end
    subject { described_class.ending_soon }

    it { should include @soon }
    it { should include @sooner }
    it { should_not include @not_soon }
    it { should_not include @in_other_state }

    it 'orders auctions by creation date, order first' do
      expect(subject[0]).to eq(@sooner)
      expect(subject[1]).to eq(@soon)
    end
  end

  context "instance" do
    describe '#to_hash' do
      let(:expected_datetime)    { auction.created_at.to_datetime }
      let(:expected_description) do
        'some rendered description'
      end
      let(:expected_hash) do
        hash = auction.attributes.symbolize_keys
        hash.delete :auctionable_id
        hash.delete :auctionable_type
        hash.delete :id
        hash[:buy_now_price] = hash.delete :price
        hash[:country_id]    = AlleApi::Client::COUNTRY_POLAND
        hash[:title]         = auction.title
        hash[:category_id]   = auction.category_id
        hash[:starts_at]     = expected_datetime
        hash[:description]   = expected_description
        hash[:duration]      = default_duration
        hash[:type]          = default_type

        hash
      end
      let(:default_duration) { 777 }
      let(:default_type) { 555 }

      before do
        auction.stubs(description: expected_description)
      end

      # set config values only for this example and restore at the end
      around do |example|
        old_duration = AlleApi.config[:default_duration]
        old_type     = AlleApi.config[:default_type]
        AlleApi.config[:default_duration] = default_duration
        AlleApi.config[:default_type] = default_type

        example.run

        AlleApi.config[:default_duration] = old_duration
        AlleApi.config[:default_type]     = old_type
      end

      it 'returns hash of attributes' do
        auction.to_hash.should == expected_hash
      end
    end

    describe '#to_allegro_auction' do
      before do
        auction.stubs(description: 'some description')
      end

      it 'returns AlleApi::Type::Auction new instance' do
        auction.to_allegro_auction.should be_kind_of AlleApi::Type::Auction
      end

      it 'initialize AlleApi::Type::Auction with #to_hash values' do
        AlleApi::Type::Auction.expects(:new).with(auction.to_hash)

        auction.to_allegro_auction
      end
    end

    describe '#description' do
      let(:renderer) { mock() }

      # set config values only for this example and restore at the end
      around do |example|
        old_renderer = AlleApi.config[:description_renderer]
        AlleApi.config[:description_renderer] = renderer

        example.run

        AlleApi.config[:description_renderer] = old_renderer
      end

      it 'uses description_renderer to render an auction' do
        auction_id = auction.id
        auctionable_id = auction.auctionable.id

        renderer.expects(:call).with do |auction, auctionable|
          auction.should be_kind_of AlleApi::Auction
          auction.id.should == auction_id

          auctionable.should be_kind_of AlleApi::Auctionable
          auctionable.id.should == auctionable.id
        end.returns('some description')

        auction.description.should == 'some description'
      end
    end

    describe '#category_id' do
      it 'calls auctionable.category_id_for_auction' do
        auction.auctionable.expects(:category_id_for_auction).returns(123)

        auction.category_id.should == 123
      end
    end

    describe "#build_for_auctionable" do
      let(:auctionable) { create :dummy_auctionable }
      subject { AlleApi::Auction.build_for_auctionable(auctionable) }

      it { should be_new_record }
      it { should be_a AlleApi::Auction }
      its(:title) { should == auctionable.title_for_auction }
      its(:auctionable) { should == auctionable }

      %w[ economic_package_price
          priority_package_price
          economic_letter_price
          priority_letter_price ].each_with_index do |price_type, index|
        it "sets ##{price_type} based on .shipment_price_by_weight" do
          expected_price = 100 + index # make unique price for each type

          AlleApi::Auction.stubs(:shipment_price_by_weight).returns(expected_price)

          subject.send(price_type.to_sym).should == expected_price
        end
      end
    end
  end

  describe "#auctions_count on auctionable if :auctions_count is present", :slow do
    around do |example|
      silence_warnings do
        ActiveRecord::Migration.verbose = false
      end
      class AlleApi::TestAuctionable < ActiveRecord::Base
        include AlleApi::Auctionable
      end

      ActiveRecord::Base.connection.instance_eval do
        create_table :alle_api_test_auctionables do |t|
          t.integer :auctions_count, default: 0
        end
      end

      @auctionable = AlleApi::TestAuctionable.create
      example.run

      ActiveRecord::Base.connection.instance_eval do
        drop_table :alle_api_test_auctionables
      end
    end

    it 'increments auctionable.auctions_count after creating' do
      expect {
        create :auction, auctionable: @auctionable
        @auctionable.reload
      }.to change(@auctionable, :auctions_count).from(0).to(1)
    end

    it 'decrements auctionable.auctions_count after destroying' do
      auction = create :auction, auctionable: @auctionable
      @auctionable.reload

      expect {
        auction.destroy
        @auctionable.reload
      }.to change(@auctionable, :auctions_count).from(1).to(0)
    end
  end

  describe '#ends_at' do
    include_context 'freezed time'

    it 'returns nil if not published' do
      auction = create :auction, :ended
      expect(auction.ends_at).to be_nil
    end

    it 'returns published_at + 30 days if published' do
      auction = create :auction, :published, published_at: 3.days.ago
      expect(auction.ends_at).to eq(auction.published_at + 30.days)
    end
  end

  describe '#all_auctions' do
    let(:template) { create :template }
    before do
      @previous = create :auction, template: template
      @current  = create :auction, template: template
      @next     = create :auction, template: template
    end
    subject { @current }

    it '#all_auctions gets all auctions from template' do
      expect(subject.all_auctions).to eq [@previous, @current, @next]
    end
  end

  describe '#url' do
    it 'returns nil if remote_id is not present' do
      subject.remote_id = nil
      expect(subject.url).to be_nil
    end

    it 'returns proper url if remote_id is present' do
      subject.remote_id = 123
      expect(subject.url).to eq("http://allegro.pl/i#{subject.remote_id}.html")
    end
  end

  describe 'on destroy' do
    before { AlleApi::Api.any_instance.stubs(:finish_auction) }

    it 'finishes remote for published auction' do
      auction = create :auction, :published
      auction.expects(:finish_remote!)
      auction.destroy
    end

    it 'does not finish remote for non-published auction' do
      auciton = create :auction, :bought_now
      auction.expects(:finish_remote!).never
      auciton.destroy
    end
  end

  describe '#finish_remote!' do
    it 'finishes auction using api' do
      auction = create :auction, remote_id: 77
      AlleApi::Api.any_instance.expects(:finish_auction).with(77)

      auction.finish_remote!
    end
  end

end
