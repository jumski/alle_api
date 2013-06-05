if respond_to? :shared_examples
  require 'rspec/freezed_time_context'

  shared_examples 'soft removable' do
    include_context 'freezed time'

    describe '#soft_remove!' do
      it 'sets soft_removed_at' do
        subject.soft_remove!

        actual = subject.soft_removed_at.in_time_zone.to_s
        expected = DateTime.now.in_time_zone.to_s
        expect(actual).to eq(expected)
      end

      it 'raises validation error if record invalid' do
        subject.stubs(valid?: false)

        expect {
          subject.soft_remove!
        }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    describe '#soft_removed?' do
      it 'is true if soft_removed_at is present' do
        subject.soft_removed_at = DateTime.now

        expect(subject).to be_soft_removed
      end

      it 'is false if soft_removed_at is nil' do
        expect(subject).to_not be_soft_removed
      end
    end

    context 'scopes' do
      before do
        @present = create factory
        @removed = create factory, soft_removed_at: DateTime.now
      end

      describe '.present' do
        subject { described_class.present.to_a }

        it { should include @present }
        it { should_not include @removed }
      end

      describe '.soft_removed' do
        subject { described_class.soft_removed.to_a }

        it { should include @removed }
        it { should_not include @present }
      end
    end
  end
end
