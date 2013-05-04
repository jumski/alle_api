
shared_examples 'auction' do
  context 'relations' do
    it { should belong_to(:auctionable) }
    it { should belong_to(:account) }
  end

  context 'validations', :validations do
    before { subject.stubs(weighted_title_length: 50) }

    numeric_fields =
      %w[ price
          economic_package_price
          priority_package_price
          economic_letter_price
          priority_letter_price ].map(&:to_sym)

    all_fields = numeric_fields + [:auctionable]

    all_fields.each do |field|
      it { should validate_presence_of field }
    end

    numeric_fields.each do |field|
      it { should validate_numericality_of field }
    end

    it 'is invalid when title contains word longer than 30 chars' do
      auction = build_stubbed factory, title: 'a'*31
      auction.stubs(weighted_title_length: 50)

      expect(auction).to be_invalid
    end

    it 'is valid when title contains words not longer than 30 chars ' do
      auction =  build_stubbed factory, title: 'a'*30
      auction.stubs(weighted_title_length: 50)

      expect(auction).to be_valid
    end

    it 'is valid when #weighted_title_length is 50 chars' do
      auction =  build_stubbed factory
      auction.stubs(weighted_title_length: 50)

      expect(auction).to be_valid
    end

    it 'is invalid when #weighted_title_length is 51 chars' do
      auction =  build_stubbed factory
      auction.stubs(weighted_title_length: 51)

      expect(auction).to be_invalid
      expect(auction.errors.keys).to eq([:title])
    end

  end

  describe '#weighted_title_length', :instance do
    let(:weighted_length) { subject.weighted_title_length }

    it 'returns zero if title is nil' do
      subject.title = nil
      expect(weighted_length).to eq(0)
    end

    it 'counts normal chars as is' do
      subject.title = 'abc123'
      expect(weighted_length).to eq(subject.title.length)
    end

    it 'counts < as 4 characters' do
      subject.title = '<'
      expect(weighted_length).to eq(4)
    end

    it 'counts > as 4 characters' do
      subject.title = '>'
      expect(weighted_length).to eq(4)
    end

    it 'counts & as 5 characters' do
      subject.title = '&'
      expect(weighted_length).to eq(5)
    end

    it 'counts " as 6 characters' do
      subject.title = '"'
      expect(weighted_length).to eq(6)
    end
  end
end
