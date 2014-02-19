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

    describe '.suggestions_for_books', :xxx do
      before do
        name = 'Lexicons'
        @branch                  = create :category, :with_condition_field, :branch, name: name
        @leaf                    = create :category, :with_condition_field, name: name
        @other_leaf              = create :category, :with_condition_field, name: 'Other'
        @removed                 = create :category, :removed, :with_condition_field, name: name
        @without_condition_field = create :category, name: name
      end
      subject do
        described_class.suggestions_for_books('lex').map{|cat| cat["id"]}
      end

      it { should include @leaf.id }
      it { should_not include @branch.id }
      it { should_not include @other_leaf.id }
      it { should_not include @removed.id }
      it { should_not include @without_condition_field.id }
    end
  end

  context 'instance methods' do
    describe '#fid_for_condition' do
      let(:condition_field) { create :field, :condition_field }

      context 'when #condition_field is present' do
        subject { create :category }
        before { subject.stubs(condition_field: condition_field) }

        it 'returns id of condition field' do
          expect(subject.fid_for_condition).to eq(condition_field.id)
        end
      end

      context 'when #condition_field is missing' do
        let(:other_field) { create :field }
        let(:parent) { create :category, fields: parent_fields }
        subject { create :category, parent: parent }
        before { subject.stubs(condition_field: nil) }

        context 'when some of parents have condition field' do
          let(:parent_fields) { [other_field, condition_field] }

          it 'gets fid_for_condition from parent' do
            expect(subject.fid_for_condition).to eq(condition_field.id)
          end
        end

        context 'when none of parents have condition field' do
          let(:parent_fields) { [other_field] }

          it 'raises CannotFindFidForConditionError' do
            expect {
              subject.fid_for_condition
            }.to raise_error(AlleApi::CannotFindFidForConditionError)
          end
        end

      end
    end

    describe '#condition_field' do
      let(:other_field) { create :field, name: 'other name' }

      context 'when no field with name equal to CONDITION_FIELD_NAME present' do
        subject { create :category, fields: [other_field] }

        it 'returns nil' do
          expect(subject.condition_field).to be_nil
        end
      end

      context 'when field with name equal to CONDITION_FIELD_NAME is present' do
        let(:condition_field) { create :field, name: AlleApi::Field::CONDITION_FIELD_NAME }
        subject { create :category, fields: [other_field, condition_field] }

        it 'returns condition field' do
          field = subject.condition_field

          expect(field).to be_a AlleApi::Field
          expect(field).to be_condition_field
        end
      end
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

      expect(@one.reload).to be_persisted
      expect(@one.parent).to eq(@two)

      expect(@two.reload).to be_persisted
      expect(@two.parent).to eq(@three)

      expect(@three.reload).to be_persisted
      expect(@three.parent_id).to be_nil
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
    it 'sets leaf_node to true if category has no children' do
      node = create :category
      leaf = create :category, parent: node

      described_class.update_leaf_nodes!

      expect(node).to be_persisted
      expect(node.reload).to_not be_leaf_node

      expect(leaf).to be_persisted
      expect(leaf.reload).to be_leaf_node
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
  end
end
