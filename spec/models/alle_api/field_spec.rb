require 'spec_helper'
require 'rspec/soft_removable_examples'

describe AlleApi::Field do
  include_examples 'soft removable' do
    let(:factory) { :field }
  end

  describe :Associations do
    it { should belong_to :category }
  end

  describe '.create_from_allegro' do
    subject { described_class.create_from_allegro(attributes) }

    def self.it_creates_a_new_field
      it { should be_a described_class }
      it { should be_persisted }
      its(:id) { should eq 999 }
    end

    context 'when category_id is 0' do
      let(:attributes) do
        attributes_for :field, id: 999, category_id: 0
      end

      it_creates_a_new_field
      its(:category_id) { should be_nil }
    end

    context 'when category_id is greater than 0' do
      let(:category) { create :category }
      let(:attributes) do
        attributes_for :field, id: 999, category_id: category.id
      end

      it_creates_a_new_field
      its(:category_id) { should eq category.id }
    end
  end

  describe '#condition_field' do
    it 'returns true if name matches' do
      subject.name = described_class::CONDITION_FIELD_NAME

      expect(subject).to be_condition_field
    end

    it 'returns false if name does not matches' do
      subject.name = 'some other name'

      expect(subject).to_not be_condition_field
    end
  end

  describe ".condition_fields" do
    it 'returns only fields that represents a condition' do
      condition_field = create :field, :condition_field
      other_field = create :field

      expect(described_class.condition_fields).to eq [condition_field]
    end
  end
end
