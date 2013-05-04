require 'spec_helper'

describe AlleApi::Helper::FieldsSynchronizer do

  include_examples 'synchronizer' do
    let(:component)   { :fields }
    let(:model_klass) { AlleApi::Field }
    let(:factory)     { :field }
    let(:api_action)  { :get_fields }
  end

end
