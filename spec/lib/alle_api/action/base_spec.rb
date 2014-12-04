
require 'spec_helper'
require 'rspec/allegro'

describe AlleApi::Action::Base do
  include_context 'mocked api client'

  let(:soap_action) { 'some_action' }
  subject { described_class.new(client) }

  before do
    subject.stubs(soap_action: soap_action)
  end

  let(:body)    { 'some body' }
  let(:args)    { [1,2,3] }
  let(:results) {
    stub(to_hash: {"#{soap_action}_response".to_sym => expected_return_value} )
  }
  let(:expected_return_value) { 'some result value' }

  describe '#do' do
    it 'calls validate! with provided params' do
      client.stubs(request: results)
      subject.stubs(:request_body)
      subject.stubs(:extract_results)
      subject.expects(:validate!).with(*args)

      subject.do(*args)
    end

    it 'calls client.request with proper arguments' do
      subject.stubs(:validate!)
      subject.stubs(:extract_results)

      subject.expects(:request_body).with(*args).returns(body)
      client.expects(:request).with(soap_action, body).returns(results)

      subject.do(*args)
    end

    it 'calls extract_results with processed values returned from request' do
      subject.stubs(:validate!)
      subject.stubs(:request_body)
      client.stubs(request: results)

      subject.expects(:extract_results).with(expected_return_value)

      subject.do(*args)
    end
  end

  describe '#validate!' do
    it 'is a no-op and does not raise anything' do
      expect { subject.validate!(1, 2, 3) }.to_not raise_error
    end
  end
end

