
module AlleApiAuctionMacros
  def it_has_default_values_for_all_fvalues_except(key)
    it 'has fvalue-string equal to "" (empty string)' do
      subject['fvalue-string'].should == ""
    end unless key == 'fvalue-string'

    it 'has fvalue-int equal to 0' do
      subject['fvalue-int'].should == 0
    end unless key == 'fvalue-int'

    it 'has fvalue-float equal to 0' do
      subject['fvalue-float'].should == 0
    end unless key == 'fvalue-float'

    it 'has fvalue-image equal to " " (one whitespace)' do
      subject['fvalue-image'].should == " "
    end unless key == 'fvalue-image'

    it 'has fvalue-datetime equal to 0' do
      subject['fvalue-datetime'].should == 0
    end unless key == 'fvalue-datetime'

    it 'has fvalue-boolean equal to false' do
      subject['fvalue-boolean'].should be_false
    end unless key == 'fvalue-boolean'

    it 'has 7 keys' do
      subject.keys.size.should == 7
    end
  end

  def it_has_value_set_under_key(key)
    it "has value populated under #{key} key" do
      subject[key].should == value
    end
  end

  def it_has_proper_fid
    it 'has fid set to value of .fid_for_attribute(attribute.to_sym, nil)' do
      described_class.expects(:fid_for_attribute)
                      .with(attribute.to_sym, nil)
                      .returns('some fid')

      subject['fid'].should == 'some fid'
    end
#
#     it "it has fid = #{fid}" do
#       subject['fid'].should == AlleApi::Auction.fid_for_attribute(attribute)
#     end
  end
end
