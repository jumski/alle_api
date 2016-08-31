# encoding: utf-8
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Client do
  include_context 'mocked api client'
  subject { client }

  its(:country_id)     { should == AlleApi::Client::COUNTRY_POLAND }
  its(:webapi_key)     { should eq(webapi_key) }
  its(:login)          { should eq(login) }
  its(:password)       { should eq(password) }
  its(:version_key)    { should eq(version_key) }

  describe "#api" do
    subject { client.api }

    it { should be_a AlleApi::Api }
    its(:client) { should eq client }
  end

  describe "#client" do
    its(:client) { should be_a Savon::Client }

    it 'parses wsdl correctly' do
      expect(client.client.operations).to be_an Array
    end

    it 'has proper globals' do
      opts = client.client.globals

      expect(opts[:convert_request_keys_to]).to eq :lower_camelcase
    end

    it 'has proper wsdl path for production mode' do
      AlleApi.config.stubs(sandbox: false)

      opts = client.client.globals

      expect(File.exist? opts[:wsdl]).to be_true
    end

    it 'has proper wsdl path for sandbox mode' do
      AlleApi.config.stubs(sandbox: true)

      opts = client.client.globals

      expect(File.exist? opts[:wsdl]).to be_true
    end
  end

  describe "#request" do
    it 'makes request using client#call' do
      params = { a: 'aaa', b: 'bbb' }
      client.client.expects(:call).with(:action, message: params).returns(:return_value)

      expect(client.request(:action, params)).to eq :return_value
    end
  end

  context 'session handle' do
    let(:redis_key) { "client:#{login}:session_handle" }

    describe '#session_handle' do
      it 'gets value from redis for given login if present' do
        AlleApi.redis.expects(:get).with(redis_key).returns('some handle')

        expect(subject.session_handle).to eq('some handle')
      end

      context "when no session handle present" do
        before do
          AlleApi.redis.stubs(:get).with(redis_key).returns(nil)
        end

        it 'makes a request for new handle' do
          client.api.expects(:authenticate).returns('session-handle')

          expect(client.session_handle).to eq 'session-handle'
        end

        it 'saves fresh session handle' do
          client.api.expects(:authenticate).returns('session-handle').once
          client.expects(:session_handle=).with('session-handle').returns('session-handle')

          expect(client.session_handle).to eq 'session-handle'
        end
      end

      context "webapi error handling" do
        let(:savon_client) { client.client }

        context "when got ERR_NO_SESSION savon error" do
          let(:error) { build_savon_fault '(ERR_NO_SESSION) Irrelevant text message!' }
          let(:client_call_sequence) { sequence('order of client#call calls') }

          it '#request authenticates and retries' do
            savon_client.expects(:call).
                         with(:get_journal, message: {}).
                         raises(error).
                         in_sequence(client_call_sequence)

            client.api.expects(:authenticate).returns('session-handle').once
            client.expects(:session_handle=).with('session-handle').once

            savon_client.expects(:call).
                         with(:get_journal, message: { session_handle: 'session-handle' }).
                         returns('23').
                         in_sequence(client_call_sequence)

            expect(client.request(:get_journal, {})).to eq '23'
          end
        end

        context "when other webapi error occurs" do
          let(:error) { build_savon_fault '(ERR_OTHER_ERROR) Irrelevant text message!' }

          before do
            savon_client.expects(:call).with(:get_journal, message: { starting_point: 123 }).raises(error)
          end

          it 'does not swallow other errors' do
            expect {
              client.request(:get_journal, starting_point: 123)
            }.to raise_error(error)
          end

          it 'does not authenticate' do
            client.api.expects(:authenticate).never

            client.request(:get_journal, starting_point: 123) rescue nil
          end
        end

        def build_savon_fault(message)
            Savon::SOAPFault.new(nil, nil, nil).tap do |error|
              error.stubs(message:message,
                          to_hash: {}, to_s: '') # hacks for 'unknown body|find' error
                                                 # called by mocha
            end
        end

        context "http integration test", :http do
          include_context 'real api client'
          include_context 'allow http connections'

          let(:message) do
            { session_handle: client.session_handle,
              starting_point: 123,
              info_type:      0 }
          end

          before { account.update_attribute :utility, true }
          before { AlleApi::Helper::Versions.new.update :version_key }

          it 'authenticates automatically when session handle is nil' do
            expect(client.request :do_get_site_journal, message).to be_a Savon::Response
          end

          it 'authenticates automatically when session handle is invalid' do
            client.session_handle = 'invalid'

            expect(client.request :do_get_site_journal, message).to be_a Savon::Response
          end
        end
      end
    end

    describe '#session_handle=' do
      it 'sets redis value with ttl using key with login ' do
        expiration = 55.minutes
        AlleApi.redis.expects(:setex).with(redis_key, expiration, 'handle')

        subject.session_handle = 'handle'
      end
    end
  end
end
