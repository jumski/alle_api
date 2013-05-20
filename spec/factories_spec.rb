require 'spec_helper'

describe "Factories:" do
  SKIPPED_TRAITS = []

  def self.it_builds(trait = nil)
    title = "builds"
    title+= "trait :#{trait}" if trait

    it title do
      record = build(subject.name, trait)

      if record.respond_to?(:valid?) && !record.valid?
        msg = "Expected to be valid, but is invalid with errors:" +
              " #{record.errors.full_messages}"

        fail msg
      end
    end
  end

  FactoryGirl.factories.each do |factory|
    context "#{factory.name} factory" do
      subject { factory }

      it_builds

      traits = factory.defined_traits.reject do |trait|
        SKIPPED_TRAITS.include? trait.name
      end

      traits.each { |trait| it_builds(trait.name) }
    end

  end
end
