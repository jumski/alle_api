
shared_context 'silenced logger' do
  around do |example|
    @old_logger = described_class.logger
    described_class.logger = Logger.new('/dev/null')

    example.run

    described_class.logger = @old_logger
  end
end
