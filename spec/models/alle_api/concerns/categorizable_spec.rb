

require 'spec_helper'

silence_warnings do
  ActiveRecord::Migration.verbose = false
end

class AlleApi::DummyCategorizable < ActiveRecord::Base
  include AlleApi::Categorizable
end

describe AlleApi::Categorizable, :slow do
  around do |example|
    ActiveRecord::Base.connection.instance_eval do
      create_table :alle_api_dummy_categorizables do |t|
        t.integer :category_id
      end
    end

    example.run

    ActiveRecord::Base.connection.instance_eval do
      drop_table :alle_api_dummy_categorizables
    end
  end

  let(:klass) { AlleApi::DummyCategorizable }
  let(:instance) { klass.new }
  subject { instance }

  it { should belong_to :category }
  it { should validate_presence_of :category }
  it { should delegate(:name).to(:category).with_prefix }

  it 'allows only leaf_node category to be set' do
    not_leaf = create :category, leaf_node: false
    categorizable = klass.new category: not_leaf

    categorizable.should_not be_valid
    categorizable.errors.full_messages.each do |message|
      message.should =~ /leaf node/
    end
  end
end
