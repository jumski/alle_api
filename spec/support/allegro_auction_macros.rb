
module AlleApiAuctionMacros
  def it_has_default_values_for_all_fvalues_except(key)
    it 'has all empty values right' do
      subject.keys.size.should == 6
      subject[:fvalueString].should == ""     unless key == :fvalueString
      subject[:fvalueInt].should == 0         unless key == :fvalueInt
      subject[:fvalueFloat].should == 0       unless key == :fvalueFloat
      subject[:fvalueImage].should == " "     unless key == :fvalueImage
      subject[:fvalueDatetime].should == 0    unless key == :fvalueDatetime
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

      subject[:fid].should == 'some fid'
    end
  end
end
