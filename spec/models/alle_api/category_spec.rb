require 'spec_helper'
require 'rspec/soft_removable_examples'

describe AlleApi::Category do
  subject { build :category }

  include_examples 'soft removable' do
    let(:factory) { :category }
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  describe :Associations do
    it { should have_many :fields }
  end

  context 'scopes' do
    describe '.without_root_nodes' do
      it 'calls .from_depth with 1' do
        described_class.expects(:from_depth).with(1).returns(described_class)
        described_class.without_root_nodes
      end
    end

    describe '.leaf_nodes' do
      let(:parent) { create :category, leaf_node: false }
      let(:leaf) { create :category, parent: parent}

      it 'calls .where and selects only nodes with leaf_node == true' do
        leaf_nodes = described_class.leaf_nodes
        leaf_nodes.should include leaf
        leaf_nodes.should_not include parent
      end
    end

    describe '.books_subtree' do
      it 'calls .children_of(7)' do
        described_class.expects(:descendants_of).with(7).returns(described_class)
        described_class.books_subtree
      end
    end

    describe '.suggestions_for_books' do
      before do
        name = 'Lexicons'
        @branch                  = create :category, :with_cached_condition_field, :branch, name: name
        @leaf                    = create :category, :with_cached_condition_field, name: name
        @other_leaf              = create :category, :with_cached_condition_field, name: 'Other'
        @removed                 = create :category, :removed, :with_cached_condition_field, name: name
        @without_condition_field = create :category, name: name

        @child = create :category, name: name, parent: @branch
        AlleApi::Category.cache_condition_field!
      end
      subject do
        described_class.suggestions_for_books('lex').map{|cat| cat["id"]}
      end

      it { should include @leaf.id }
      it { should include @child.id }
      it { should_not include @branch.id }
      it { should_not include @other_leaf.id }
      it { should_not include @removed.id }
      it { should_not include @without_condition_field.id }
    end
  end

  describe "#fid_for_condition" do
    it 'returns fid of a condition_field if present' do
      field = create :field, :condition_field
      category = create :category, condition_field: field

      expect(category.fid_for_condition).to eq field.id
    end

    it 'raises error if condition_field is missing' do
      AlleApi::Category.any_instance.stubs(condition_field: false)
      category = build_stubbed :category

      expect {
        category.fid_for_condition
      }.to raise_error AlleApi::CannotFindFidForConditionError
    end
  end

  describe '#suggestions_for' do
    pending 'add specs for #suggestions_for'
  end

  context 'defaults' do
    its(:leaf_node?) { should be_true }
  end

  describe '.create_from_allegro' do
    it 'assigns all attributes' do
      attributes = { id: 77, name: 'name', parent_id: 66, position: 23 }
      category = described_class.create_from_allegro(attributes)

      expect(category).to be_a described_class
      expect(category).to be_persisted
      expect(category.id).to eq(77)
      expect(category.name).to eq('name')
      expect(category.allegro_parent_id).to eq(66)
      expect(category.position).to eq(23)
    end
  end

  describe '.assign_proper_parents!' do
    before do
      @one = create :category, id: 1, allegro_parent_id: 2
      @two = create :category, id: 2, allegro_parent_id: 3
      @three = create :category, id: 3
    end

    it 'sets parent_id to allegro_parent_id for each record' do
      described_class.assign_proper_parents!

      expect(@one.reload.parent).to eq(@two)
      expect(@two.reload.parent).to eq(@three)
      expect(@three.reload.parent_id).to be_nil
    end

    it 'does not update soft removed categories' do
      @one.soft_remove!

      expect {
        described_class.assign_proper_parents!
        @one.reload
      }.to_not change(@one, :parent)
    end

    it 'nilifies allegro_parent_id' do
      described_class.assign_proper_parents!

      ids = described_class.pluck(:allegro_parent_id).compact
      expect(ids).to eq([])
    end

    it 'checks ancestry integrity' do
      described_class.expects(:check_ancestry_integrity!)

      described_class.assign_proper_parents!
    end
  end

  describe '.update_leaf_nodes!' do
    it 'sets leaf_node to false if category has children' do
      non_leaf = create :category
      create :category, parent: non_leaf

      expect {
        described_class.update_leaf_nodes!
        non_leaf.reload
      }.to change(non_leaf, :leaf_node?).from(true).to(false)
    end

    it 'does not update soft removed categories' do
      non_leaf = create :category, :removed
      create :category, parent: non_leaf

      expect {
        described_class.update_leaf_nodes!
        non_leaf.reload
      }.to_not change(non_leaf, :leaf_node?).from(true).to(false)
    end

    it 'does not update leaf node if all children are soft_removed' do
      non_leaf = create :category
      create :category, :removed, parent: non_leaf

      expect {
        described_class.update_leaf_nodes!
        non_leaf.reload
      }.to_not change(non_leaf, :leaf_node?).from(true).to(false)
    end

    it 'sets leaf_node to false if some children are present' do
      non_leaf = create :category
      create :category, parent: non_leaf
      create :category, :removed, parent: non_leaf

      expect {
        described_class.update_leaf_nodes!
        non_leaf.reload
      }.to change(non_leaf, :leaf_node?).from(true).to(false)
    end
  end

  describe '.update_path_texts!' do
    it 'updates path_text for each leaf category' do
      node_a = create :category, leaf_node: false
      node_b = create :category, leaf_node: false, parent: node_b
      leaf_a = create :category, parent: node_a
      leaf_b = create :category, parent: node_b

      described_class.update_path_texts!

      expect(node_a.reload.path_text).to be_nil
      expect(node_b.reload.path_text).to be_nil

      expect(leaf_a.reload).to be_persisted
      leaf_a.reload
      leaf_a_path = leaf_a.path.pluck(:name).join(' > ')
      expect(leaf_a.path_text).to eq(leaf_a_path)

      expect(leaf_b.reload).to be_persisted
      leaf_b_path = leaf_b.path.pluck(:name).join(' > ')
      expect(leaf_b.path_text).to eq(leaf_b_path)
    end

    it 'does not update soft removed categories' do
      node_a = create :category, leaf_node: false
      leaf_a = create :category, :removed, parent: node_a

      expect {
        described_class.update_path_texts!
        leaf_a.reload
      }.to_not change(leaf_a, :path_text)
    end
  end

  describe ".cache_condition_field! settings has_condition_field" do
    let!(:category) { create :category, :with_condition_field }
    let(:condition_field) { category.fields.condition_fields.first }

    it 'caches condition_field on source category' do
      expect {
        described_class.cache_condition_field!
        category.reload
      }.to change(category, :condition_field).to(condition_field)
    end

    it 'caches condition_field on immediate children' do
      child = create :category, parent: category

      expect {
        described_class.cache_condition_field!
        child.reload
      }.to change(child, :condition_field).to(condition_field)
    end

    it 'caches condition_field on non-immediate children' do
      child = create :category, parent: category
      descendant = create :category, parent: child

      expect {
        described_class.cache_condition_field!
        descendant.reload
      }.to change(descendant, :condition_field).to(condition_field)
    end

    it 'does not change other categories' do
      non_child = create :category

      expect {
        described_class.cache_condition_field!
        non_child.reload
      }.to_not change(non_child, :condition_field)
    end
  end

  describe "#selectable?" do
    it 'is false if soft removed' do
      subject.stubs(soft_removed?: true)

      expect(subject).to_not be_selectable
    end

    it 'is false if condition_field is nil' do
      subject.condition_field = nil

      expect(subject).to_not be_selectable
    end

    it 'is false if not leaf node' do
      subject.leaf_node = false

      expect(subject).to_not be_selectable
    end

    it 'is true for not removed leaf nodes with condition field' do
      subject.condition_field = build_stubbed :field, :condition_field
      subject.stubs(soft_removed?: false, leaf_node: true)

      expect(subject).to be_selectable
    end
  end
end
