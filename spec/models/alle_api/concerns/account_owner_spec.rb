
require 'spec_helper'

silence_warnings do
  ActiveRecord::Migration.verbose = false
end

class AlleApi::DummyAccountOwner < ActiveRecord::Base
  include AlleApi::AccountOwner
end

describe AlleApi::AccountOwner, :slow do
  around do |example|
    ActiveRecord::Base.connection.instance_eval do
      create_table :alle_api_dummy_account_owners
    end

    example.run

    ActiveRecord::Base.connection.instance_eval do
      drop_table :alle_api_dummy_account_owners
    end
  end

  let(:klass) { AlleApi::DummyAccountOwner }
  let(:instance) { klass.new }
  subject { instance }

  it { should have_many :allegro_accounts }
  it { should have_many(:auction_templates).through(:allegro_accounts) }
  it { should have_many(:auctions).through(:allegro_accounts) }
  it 'has proper auctions association setup' do
    expect { subject.auctions }.to_not raise_error
  end
  it 'has proper auction templates association setup' do
    expect { subject.auction_templates }.to_not raise_error
  end

end
