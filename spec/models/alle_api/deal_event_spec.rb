require 'spec_helper'

describe AlleApi::DealEvent do
  it { should belong_to :auction }

  AlleApi::DealEvent::ACCESSIBLE.each do |attr|
    it { should validate_presence_of attr }
  end

  AlleApi::DealEvent::NUMERICAL.each do |attr|
    it { should validate_numericality_of attr }
  end
end
