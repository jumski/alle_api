require 'spec_helper'
require 'rspec/allegro'
require 'shared/wrapper'

describe AlleApi::Wrapper::Field do
  include_examples 'wrapper'

  context :Coercions do
    context 'when attribute name contains id' do
      attributes = described_class::ATTRIBUTES.select do |name|
        name.to_s =~ /id/
      end

      attributes.each do |name|
        it "coerces #{name} to integer" do
          subject[name] = "123"

          expect(subject[name]).to be_an Integer
          expect(subject[name]).to eq(123)
        end
      end
    end

    context 'when attribute name contains max, min or length' do
      attributes = described_class::ATTRIBUTES.select do |name|
        name.to_s =~ /(max|min|length)/
      end

      attributes.each do |name|
        it "coerces #{name} to float" do
          subject[name] = "123"

          expect(subject[name]).to be_an Float
          expect(subject[name]).to eq(123.0)
        end
      end
    end

    context 'when attribute name does not contain id, max, min or length' do
      attributes = described_class::ATTRIBUTES.reject do |name|
        name.to_s =~ /(id|max|min|length)/
      end

      attributes.each do |name|
        it "coerces #{name} to string" do
          subject[name] = "123"

          expect(subject[name]).to be_an String
          expect(subject[name]).to eq("123")
        end
      end
    end
  end
end
