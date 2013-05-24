require 'spec_helper'

describe AlleApi::PostBuyForm do
  it { should belong_to :account }
  it { should have_many :deal_events }

  it { should validate_uniqueness_of :remote_id }

  # it { should enumerize(:payment_status).
  #        in(:started, :cancelled, :rejected, :finished, :withdrawn).
  #        with_default(:started) }
end
