require 'spec_helper'
require 'shared/wrapper'

describe AlleApi::Wrapper::ShipmentAddress do
  extend WrapperMacros

  converts_nil_hash_to_nil_for :full_name
  converts_nil_hash_to_nil_for :company_name
  converts_nil_hash_to_nil_for :address_1
  converts_nil_hash_to_nil_for :city
  converts_nil_hash_to_nil_for :phone_number
end
