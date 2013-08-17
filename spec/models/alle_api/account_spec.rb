require 'spec_helper'

describe AlleApi::Account do
  subject { build :account }

  it { should have_many :auctions }
  it { should have_many :templates }
  it { should have_many :auction_events }
  it { should have_many :post_buy_forms }
  it { should have_many :deal_events }
  it { should belong_to :owner }

  it { should validate_presence_of :login }
  it { should validate_presence_of :password }

  # workaround for https://github.com/thoughtbot/shoulda-matchers/issues/194
  context 'with saved account' do
    subject { create :account }
    it { should validate_uniqueness_of(:login) }
  end

  it { should ensure_length_of(:password).
                is_at_least(6).
                is_at_most(16) }
  it { should validate_numericality_of :last_processed_event_id }
  it { should validate_presence_of :remote_id }

  it 'allows mass assigning of login and password' do
    expect {
      described_class.new(login: 'a', password: 'b')
    }.to_not raise_error
  end

  describe '.utility' do
    it 'returns utility account' do
      normal = create :account
      utility = create :account, utility: true

      expect(described_class.utility.id).to eq(utility.id)
    end
  end

  describe '#api' do
    it 'instantiates api with proper params' do
      subject.stubs(credentials: 'credentials')
      AlleApi::Api.expects(:new).with('credentials').returns('api')

      expect(subject.api).to eq('api')
    end
  end

  describe '#client' do
    it 'gets client from api' do
      subject.stubs(api: stub(client: 'client'))

      expect(subject.client).to eq('client')
    end
  end

  describe '#credentials' do
    it 'it is a hash of paramteters' do
      subject.stubs(login: 'abcd', password: 'defg')
      AlleApi.config.stubs(webapi_key: 'webapi key')
      AlleApi.stubs(versions: {version_key: 'version key'})
      expected = {
        login: 'abcd',
        password: 'defg',
        webapi_key: 'webapi key',
        version_key: 'version key'
      }

      expect(subject.credentials).to eq(expected)
    end
  end

  context 'when no auction events present' do
    subject { create :account }

    it 'returns last_processed_event_id' do
      expect(subject.last_auction_event_remote_id).to \
          eq(subject.last_processed_event_id)
    end
  end

  context 'when some auction events present' do
    subject { create :account }
    before do
      @events = []
      @events << create(:auction_event_start, remote_id: 10, account: subject)
      @events << create(:auction_event_end, remote_id: max_id, account: subject)
    end
    let(:max_id) { 15 }

    it 'last_auction_event_remote_id is max id of events' do
      expect(subject.last_auction_event_remote_id).to eq(max_id)
    end
  end

  context 'when some deal events present' do
    before do
      @account = create :account
      auction = create :auction, account: @account
      create_list :new_deal, 2, auction: auction
      create_list :new_deal, 2, auction: create(:auction)
    end

    it '#last_deal_event_remote_id returns max remote id' do
      expected = @account.deal_events.maximum(:remote_id)

      expect(@account.last_deal_event_remote_id).to eq expected
    end
  end

  context "when no deal events present" do
    before { @account = create :account }

    it '#last_deal_event_remote_id returns 0' do
      expect(@account.last_deal_event_remote_id).to eq 0
    end
  end

  context 'with some events' do
    let(:other_account) { create :account }

    before do
      @triggered = create :auction_event_update,
        :triggered, account: subject
      @untriggered = create :auction_event_update, account: subject

      @other_triggered = create :auction_event_update,
        :triggered, account: other_account
      @other_untriggered = create :auction_event_update,
        :triggered, account: other_account
    end

    describe '#triggered_events' do
      let(:events) { subject.triggered_events }

      it 'includes triggered event from this account' do
        expect(events).to include(@triggered)
      end
      it 'excludes untriggered event from this account' do
        expect(events).to_not include(@untriggered)
      end
      it 'excludes triggered event from other account'  do
        expect(events).to_not include(@other_triggered)
      end
      it 'excludes untriggered event from other account' do
        expect(events).to_not include(@other_untriggered)
      end
    end

    describe '#untriggered_events' do
      let(:events) { subject.untriggered_events }

      it 'includes untriggered event from this account' do
        expect(events).to include(@untriggered)
      end
      it 'excludes triggered event from this account' do
        expect(events).to_not include(@triggered)
      end
      it 'excludes triggered event from other account' do
        expect(events).to_not include(@other_triggered)
      end
      it 'excludes untriggered event from other account' do
        expect(events).to_not include(@other_untriggered)
      end
    end
  end

  describe ".missing_transaction_ids" do
    it 'forwards to deal_events' do
      subject.stubs(deal_events: stub(missing_transaction_ids: [1,2,3]))

      expect(subject.missing_transaction_ids).to eq [1,2,3]
    end
  end

  it "#about_me_url" do
    url = "http://allegro.pl/my_page.php?uid=#{subject.remote_id}"

    expect(subject.about_me_url).to eq url
  end

end
