require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Client do
  include_context 'mocked api client'
  subject { client }

  it { should be_a Savon::Client }

  it 'wsdl file is valid' do
    subject.wsdl.soap_actions.should be_an Array
  end

  # it "#initialize sets http.auth.ssl.verify_mode to :none" do
  #   subject.http.auth.ssl.verify_mode.should == :none
  # end

  its(:country_id)     { should == AlleApi::Client::COUNTRY_POLAND }
  its(:webapi_key)     { should eq(webapi_key) }
  its(:login)          { should eq(login) }
  its(:password)       { should eq(password) }
  its(:version_key)    { should eq(version_key) }

  context 'session handle' do
    let(:key) { "client:#{login}:session_handle" }

    describe '#session_handle' do
      it 'gets value from redis for given login' do
        AlleApi.redis.expects(:get).with(key).returns('some handle')

        expect(subject.session_handle).to eq('some handle')
      end
    end

    describe '#session_handle=' do
      it 'sets value to redis for given login using setex' do
        expiration = 55.minutes
        AlleApi.redis.expects(:setex).with(key, expiration, 'handle')

        subject.session_handle = 'handle'
      end
    end
  end
end
