require 'spec_helper'

describe AlleApi::Helper::ComponentsUpdater do
  include_context 'with account'
  let(:account) { create :account, utility: true }

  describe '#versions' do
    its(:versions) { should be_a AlleApi::Helper::Versions }

    it 'is memoized' do
      first = subject.versions
      second = subject.versions

      expect(first.object_id).to eq(second.object_id)
    end
  end

  describe '#update!' do
    it 'always updates AlleApi.version_key' do
      subject.versions.expects(:update).with(:version_key)
      subject.versions.stubs(changed?: false)

      subject.update!
    end

    context 'if categories tree changes' do
      before do
        subject.versions.stubs(:update)
        subject.versions.expects(:changed?).with(:categories_tree).returns(true)
        subject.versions.expects(:changed?).with(:fields).returns(false)
      end

      it 'enqueues UpdateCategoriesTree job' do
        AlleApi::Job::UpdateCategoriesTree.expects(:perform_async)
        subject.update!
      end

      it 'does not enqueue UpdateFields job' do
        AlleApi::Job::UpdateFields.expects(:perform_async).never
        subject.update!
      end
    end

    context 'if fields changed' do
      before do
        subject.versions.stubs(:update)
        subject.versions.expects(:changed?).with(:fields).returns(true)
        subject.versions.expects(:changed?).with(:categories_tree).returns(false)
      end

      it 'enqueues UpdateCategoriesTree job' do
        AlleApi::Job::UpdateFields.expects(:perform_async)
        subject.update!
      end

      it 'does not enqueue UpdateCategoriesTree job' do
        AlleApi::Job::UpdateCategoriesTree.expects(:perform_async).never
        subject.update!
      end
    end
  end

  # context 'with stubbed api response' do
  #   before do
  #     fake_api_response = {
  #       country_id: client.country_id,
  #       fields: '2.0',
  #       categories_tree: '2.1',
  #       version_key: '4321'
  #     }

  #     api.expects(:get_versions).returns(fake_api_response)
  #   end
  # end

end
