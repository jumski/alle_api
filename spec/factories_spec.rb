require 'spec_helper'

describe "Factories:" do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    it 'does not raise any errors' do
      expect{
        built = build(factory_name)

        if built.respond_to? :valid?
          expect(built).to be_valid
        end
      }.to_not raise_error
    end
  end
end
