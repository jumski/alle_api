require 'spec_helper'

describe AlleApi::DealEvent do
  it { should belong_to :auction }
end
