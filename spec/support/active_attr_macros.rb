
module ActiveAttrHelpers
  def it_has_read_only_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "raises error when set" do
        expect {
          subject.send(name).should eq(123)
        }.to raise_error
      end
    end
  end

  def it_has_integer_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "is casted to Integer" do
        subject.send("#{name}=", '123')
        subject.send(name).should eq(123)
        subject.send(name).should be_kind_of Integer
      end
    end
  end

  def it_has_float_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "is casted to Float" do
        subject.send("#{name}=", '123')
        subject.send(name).should eq(123.0)
        subject.send(name).should be_kind_of Float
      end
    end
  end

  def it_has_boolean_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "0 is casted to false" do
        subject.send("#{name}=", 0)
        subject.send(name).should be_false
        subject.send(name).should be_kind_of FalseClass
      end

      it "empty string is casted to false" do
        subject.send("#{name}=", '')
        subject.send(name).should be_false
        subject.send(name).should be_kind_of FalseClass
      end

      it "not blank value is casted to true" do
        subject.send("#{name}=", '123')
        subject.send(name).should be_true
        subject.send(name).should be_kind_of TrueClass
      end
    end
  end

  def it_has_datetime_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "is casted to DateTime" do
        subject.send("#{name}=", '11-12-2011')
        subject.send(name).should be_kind_of DateTime
        subject.send(name).should == DateTime.parse('11-12-2011')

        subject.send(name).should be_kind_of DateTime
      end
    end
  end

  def it_has_string_attribute(name)
    context "##{name}" do
      it 'is an attribute' do
        should have_attribute(name)
      end

      it "is casted to Float" do
        subject.send("#{name}=", 123)
        subject.send(name).should eq('123')
        subject.send(name).should be_kind_of String
      end
    end
  end
end
