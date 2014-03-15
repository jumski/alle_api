shared_examples 'synchronizer' do
  include_context 'mocked api client'
  subject { described_class.new(api) }

  its(:component)   { should eq component }
  its(:model_klass) { should eq model_klass }

  describe '#synchronize!' do
    before { AlleApi.stubs(versions: mock) }

    it 'calls #synchronize' do
      subject.expects(:synchronize)
      AlleApi.stubs(versions: stub_everything)

      subject.synchronize!
    end

    it "updates local version on success" do
      subject.stubs(:synchronize)
      AlleApi.versions.expects(:update).with(component)

      subject.synchronize!
    end

    it "does not update version number on failure" do
      subject.stubs(:synchronize).raises
      AlleApi.versions.expects(:update).never

      expect { subject.synchronize! }.to raise_error
    end

    describe '#synchronize' do
      it 'calls what needs to be called' do
        AlleApi.stubs(versions: stub_everything)

        valid_import = sequence('valid import')
        subject.expects(:soft_remove_removed).in_sequence(valid_import)
        subject.expects(:import_added)
        subject.expects(:clean)

        subject.synchronize
      end
    end

    describe '#import_added' do
      let(:items) { [ stub(to_hash: 1), stub(to_hash: 2), stub(to_hash: 3)] }
      before { subject.stubs(added: items) }

      it 'creates every missing record' do
        model_klass.expects(:create_from_allegro).with(1).once
        model_klass.expects(:create_from_allegro).with(2).once
        model_klass.expects(:create_from_allegro).with(3).once

        subject.import_added
      end

      it 'returns all created records' do
        model_klass.stubs(:create_from_allegro).returns(:a).then.returns(:b).then.returns(:c)

        expect(subject.import_added).to eq [:a, :b, :c]
      end

      it 'raises if called twice' do
        model_klass.stubs(:create_from_allegro)
        subject.import_added

        expect {
          subject.import_added
        }.to raise_error /Cannot call #import_added twice!/
      end
    end

    describe '#added' do
      it 'returns all new records returned by api' do
        create factory, id: 1
        create factory, id: 2

        present, missing = {id: 1}, {id: 3}
        api.stubs(api_action => [present, missing])

        expect(subject.added).to eq([missing])
      end
    end

    describe '#soft_remove_removed' do
      before do
        @present_record = create factory, id: 1
        @removed_record = create factory, id: 2
        subject.stubs(removed: [@removed_record])
      end

      it 'soft removes every removed record with a proper timestamp' do
        Timecop.freeze(now = DateTime.now) do
          subject.soft_remove_removed

          expect(@removed_record.reload).to be_soft_removed

          actual_date = @removed_record.soft_removed_at.in_time_zone
          expect(actual_date.to_s).to eq(now.in_time_zone.to_s)
        end
      end

      it 'does not remove present record' do
        subject.soft_remove_removed

        expect(@present_record.reload).to_not be_soft_removed
      end

      it 'returns all soft removed' do
        expect(subject.soft_remove_removed).to eq [@removed_record]
      end

      it 'raises if called twice' do
        subject.soft_remove_removed

        expect {
          subject.soft_remove_removed
        }.to raise_error /Cannot call #soft_remove_removed twice!/
      end
    end

    describe '#removed' do
      it 'returns records not present in allegro' do
        present = create factory, id: 1
        removed = create factory, id: 2
        api.stubs(api_action => [{id: 1}, {id: 3}])

        expect(subject.removed).to eq([removed])
      end
    end

  end

end
