require 'spec_helper'

describe AlleApi::PostBuyForm do
  it { should belong_to :account }
  it { should have_one :deal_event }

  it { should validate_uniqueness_of :remote_id }
end
