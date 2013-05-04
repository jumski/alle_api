if respond_to? :shared_context
  require 'rspec/allegro_stubs'

  shared_context 'with account' do
    let(:account) { create :account }
    let(:api)     { account.api }
    let(:client)  { api.client }
    before do
      AlleApi::Account.any_instance.stubs(api: api)
    end
  end

  shared_context "mocked api params" do
    let(:api_config) do
      { webapi_key: webapi_key,
        version_key: version_key,
        login: login,
        password: password,
        session_handle: session_handle }
    end
    let(:version_key)    { '123456' }
    let(:webapi_key)     { 'some webapi key' }
    let(:login)          { 'some login' }
    let(:password)       { 'some password' }
    let(:session_handle) { 'handle' }
  end

  shared_context "real api params" do
    let(:api_config) do
      unless ENV['ALLE_API_CONFIG_PATH']
        raise "Please set ALLE_API_CONFIG_PATH env var!"
      end

      erb = ERB.new(File.read(ENV['ALLE_API_CONFIG_PATH']))
      yaml = YAML::load(erb.result)
      Hashie::Mash.new(yaml)[Rails.env]
    end
    let(:version_key)  { api_config[:version_key] }
    let(:webapi_key)   { api_config[:webapi_key] }
    let(:login)        { api_config[:login] }
    let(:password)     { api_config[:password] }
  end

  shared_context "real api client" do
    include_context 'real api params'
    let(:account) do
      create :account, login: login, password: password
    end
    let(:client) { api.client }
    let(:api) { account.api }

    before do
      AlleApi.config.stubs(webapi_key: api_config.webapi_key)
    end
  end

  shared_context "mocked api client" do
    include_context 'mocked api params'

    let(:api) { AlleApi::Api.new(api_config) }
    let(:client) { api.client }
    let(:session_handle) { '123' }
  end

  shared_context "categories from :do_get_cats_data" do
    let(:categories) { [category_one, category_two] }
    let(:category_one) {
      { :cat_id       => "23",
        :cat_name     => "category one",
        :cat_parent   => "0",
        :cat_position => "235",
        :"@xsi:type"  => "typens:CatInfoType" }
    }
    let(:category_two) {
      { :cat_id       => "230",
          :cat_name     => "category two",
          :cat_parent   => "23",
          :cat_position => "2350",
          :"@xsi:type"  => "typens:CatInfoType" }
    }
  end

  shared_context "body for :do_get_cats_data" do
    let(:body) do
      { "country-id"    => AlleApi::Client::COUNTRY_POLAND,
        "local-version" => version_key,
        "webapi-key"    => webapi_key }
    end
  end

  shared_context "result from :do_get_cats_data" do
    let(:result) do
      hash = {
        :do_get_cats_data_response => cats_list
      }
      stub(:to_hash => hash)
    end

    let(:cats_list) {
      {
        :cats_list => {
          :item => categories
        }
      }
    }
  end

  shared_context "stubbed request to :do_get_cats_data" do
    include_context "categories from :do_get_cats_data"
    include_context "body for :do_get_cats_data"
    include_context "result from :do_get_cats_data"

    before do
      client.stubs(:request)
            .with(:do_get_cats_data, body: body)
            .returns(result)
    end
  end

  shared_context 'stubbed get_journal events' do
    include_context 'mocked api client'

    let(:start_event) do
      { remote_id: 123,
        remote_auction_id: 321,
        remote_seller_id: 111,
        current_price: 5.23,
        occured_at: 1.days.ago,
        kind: :auction_start }
    end
    let(:end_event) do
      { remote_id: 126,
        remote_auction_id: 324,
        remote_seller_id: 114,
        current_price: 5.26,
        occured_at: 4.days.ago,
        kind: :auction_end }
    end
    let(:buy_now_event) do
      { remote_id: 129,
        remote_auction_id: 327,
        remote_seller_id: 117,
        current_price: 5.29,
        occured_at: 7.days.ago,
        kind: :auction_buy_now }
    end
    let(:events)        { [start_event, end_event, buy_now_event] }

    subject { described_class }

    before do
      api.stubs(get_journal: events)
    end
  end

  RSpec.configure do |c|
    c.alias_it_should_behave_like_to :it_implements, 'it implements:'
  end

  shared_examples 'api action' do |soap_action|
    include_context 'mocked api client'
    subject { described_class.new(client) }

    it { should be_a AlleApi::Action::Base }

    let(:soap_action) { soap_action } # hack for nexted examples

    its(:soap_action) { should == soap_action }

  end

  shared_examples 'simple #extract_results' do
    before do
      client.stubs(request: stub("#{soap_action}_response" => unextracted))
    end

    it '#extract_result returns proper results' do
      actual = subject.extract_results(unextracted)
      expect(actual).to eq(expected)
    end
  end

  shared_examples '#extract_results using wrapper' do
    it 'passess unextracted response to a wrapper factory method' do
      subject.expects(:extract_items).with('unextracted').returns('extracted')
      wrapper_klass.expects(:wrap_multiple).with('extracted').returns('wrapped')

      expect(subject.extract_results('unextracted')).to eq('wrapped')
    end
  end

  shared_examples 'simple #request_body' do
    it '#request_body is properly build' do
      body = if defined? actual_body
              actual_body
            else
              subject.request_body
            end

      expect(body).to eq(expected_body)
    end
  end


  shared_examples 'initializes and calls a helper' do
    include_context 'mocked api client'

    describe '#perform' do
      let(:fake_client) { stub }
      let(:fake_api) { stub(client: fake_client) }
      before do
        AlleApi.stubs(utility_api: fake_api)
      end

      it 'instantiates helper' do
        fake_helper = stub_everything
        helper_klass.expects(:new).with(*constructor_args).returns(fake_helper)

        subject.perform
      end

      it 'uses a helper' do
        fake_helper = mock
        helper_klass.stubs(:new).returns(fake_helper)

        fake_helper.expects(helper_method)

        subject.perform
      end

    end
  end

  shared_context 'real category' do
    let(:category_attributes) do
      # we do not want to download 30k categories
      { id:              110617,
        name:            "Polaroid",
        position:        4,
        leaf_node:       true,
        fields:          [condition_field],
        soft_removed_at: nil }
    end
    let(:condition_field) { create :field, id: 21455, name: "Stan" }
    let(:category) { create(:category, category_attributes) }
  end
end
