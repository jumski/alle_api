
shared_examples_for 'a job for each account' do
  describe ".each_account_async" do
    it 'calls perform_async for each account id' do
      accounts = create_list(:account, 2)

      called_ids = []
      described_class.stubs(:perform_async).with do |id|
        called_ids << id
      end

      described_class.each_account_async

      expect(called_ids.sort).to eq AlleApi::Account.pluck(:id).sort
    end
  end
end
