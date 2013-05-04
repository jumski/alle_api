require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Job::Authenticate do
  include_context 'silenced logger'
  include_context 'with account'

  subject { described_class.new }
  let(:account) { create :account }

  it { should be_a AlleApi::Job::Base }

  context "#perform" do
    it 'calls api#authenticate' do
      api.expects(:authenticate).returns('handle')

      subject.perform(account.id)
    end

    it 'saves session_handle to client' do
      api.stubs(authenticate: 'new handle')

      subject.perform(account.id)

      expect(client.session_handle).to eq('new handle')
    end
  end

end
