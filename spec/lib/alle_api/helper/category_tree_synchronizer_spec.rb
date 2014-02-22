require 'spec_helper'

describe AlleApi::Helper::CategoryTreeSynchronizer do

  include_examples 'synchronizer' do
    let(:component)   { :categories_tree }
    let(:model_klass) { AlleApi::Category }
    let(:factory)     { :category }
    let(:api_action)  { :get_categories }

    describe '#clean' do
      it 'calls some clening methods on Category' do
        model_klass.expects(:assign_proper_parents!)
        model_klass.expects(:update_leaf_nodes!)
        model_klass.expects(:update_path_texts!)
        model_klass.expects(:cache_condition_field!)

        subject.clean
      end
    end
  end

end
