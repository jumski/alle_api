require 'spec_helper'

# this example is used to re-record authenticate_and_update_* cassettes
describe "Authenticate and update" do
  include_context 'real api client'

  specify { authenticate_and_update! }
end
