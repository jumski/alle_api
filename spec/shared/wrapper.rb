
shared_examples 'wrapper' do
  include_context 'fields'

  it { should be_a Virtus }

  describe '.wrap_multiple' do
    let(:wrap!) { described_class.wrap_multiple(multiple) }
    let(:multiple) { %w(a b) }

    it 'instantiates array of Wrapper::Field' do
      described_class.expects(:wrap).with('a').once.returns('wrapped_a')
      described_class.expects(:wrap).with('b').once.returns('wrapped_b')

      expect(wrap!).to eq(['wrapped_a', 'wrapped_b'])
    end
  end

  describe '.wrap' do
    # check if wrap translates api names to human alleapi names
    described_class::ATTRIBUTE_NAME_TRANSLATION.each do |original, translated|
      it "wraps #{original} as #{translated}" do
        described_class.expects(:new).with({translated => '123'})

        described_class.wrap({original => '123'})
      end
    end
  end
end
