require 'spec_helper'

describe 'AlleApi::Countries' do
  subject { AlleApi::Countries }

  it { should have(220).items }

  it { should be_frozen }

  it { should be_a Hash }
end
