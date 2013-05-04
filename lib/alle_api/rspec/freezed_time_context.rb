
if respond_to? :shared_context
  shared_context "freezed time" do
    # freeze time around all examples for easy quering of timestamp attributes
    let(:time_now) { DateTime.now.in_time_zone }
    around do |example|
      Timecop.freeze time_now do
        example.run
      end
    end
  end
end
