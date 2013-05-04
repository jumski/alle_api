require 'spec_helper'

describe AlleApi::Helper::Versions do
  include_context 'with account'
  let(:account) { create :account, utility: true }

  describe '#update_version_of' do
    it 'saves new version for given component' do
      versions = {fields: '1.1'}
      AlleApi.utility_api.expects(:get_versions).returns(versions)

      subject.expects(:[]=).with(:fields, '1.1')

      subject.update_version_of(:fields)
    end
  end

  describe '#[]' do
    it 'gets version from alleapi redis using stringified key' do
      AlleApi.redis.expects(:get).with('versions:fields').returns('version')

      expect(subject[:fields]).to eq('version')
    end
  end

  describe '#[]=' do
    it 'sets version to alleapi redis using stringified key' do
      AlleApi.redis.expects(:set).with('versions:fields', 'new version')

      subject[:fields] = 'new version'
    end
  end

  describe '#changed?' do
    it 'returns false if allegro version is same as local' do
      AlleApi.utility_api.expects(:get_versions).returns({fields: '1.0'})
      subject.expects(:[]).with(:fields).returns('1.0')

      expect(subject.changed?(:fields)).to be_false
    end

    it 'returns true if allegro version is not same as local' do
      AlleApi.utility_api.expects(:get_versions).returns({fields: '1.1'})
      subject.expects(:[]).with(:fields).returns('1.0')

      expect(subject.changed?(:fields)).to be_true
    end
  end

  it 'memoizes return value of api.get_versions' do
    AlleApi.utility_api.expects(:get_versions).returns({}).once

    subject.update_version_of(:fields)
    subject.update_version_of(:categories_tree)
  end
end
