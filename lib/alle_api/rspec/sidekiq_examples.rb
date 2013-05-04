
if respond_to? :shared_examples
  RSpec.configure do |c|
    c.alias_it_should_behave_like_to :it_is_an
  end

  shared_examples 'unique job' do |expires_in|
    let(:sidekiq_opts) { described_class.sidekiq_options }

    it 'is an unique sidekiq job' do
      expect(sidekiq_opts['unique']).to be_true
    end

    if expires_in.present?
      it "is unique for #{expires_in} seconds" do
        expect(sidekiq_opts['unique_job_expiration']).to eq(expires_in)
      end
    end
  end
end
