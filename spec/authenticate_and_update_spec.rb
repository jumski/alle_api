require 'spec_helper'

# this example is used to re-record authenticate_and_update_* cassettes
describe "Authenticate and update" do
  include_context 'real api client'

  [true, false].each do |is_sandbox|
    context "when sandbox is #{is_sandbox}" do
      around do |example|
        cassette = if AlleApi.config.sandbox
                     :authenticate_and_update_sandbox
                   else
                     :authenticate_and_update_production
                   end

        VCR.use_cassette(cassette, match_requests_on: [:uri, :body]) do
          example.run
        end
      end

      it 'authenticates and updates' do
        authenticate_and_update!
      end
    end
  end
end
