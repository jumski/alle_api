
module StateMachineMacros
  def it_does_not_allow_event(event, *args)
    it "does not allow ##{event}" do
      expect {
        subject.send("#{event}!", *args)
      }.to raise_error(Workflow::NoTransitionAllowed)
    end
  end

  def it_transits_to(state)
    it "changes state to ##{state}" do
      expect {
        subject.send("#{event}!", *event_args)
        subject.reload
      }.to change(subject, :state).to(state.to_s)
    end
  end

  def it_updates_timestamp(attribute)
    it "updates #{attribute}" do
      subject.send("#{event}!", *event_args)
      subject.reload

      attr = subject.send(attribute)
      expect(attr).to_not be_nil

      timestamp = attr.utc.in_time_zone.to_s
      now = time_now.utc.in_time_zone.to_s

      expect(timestamp).to eq(now)
    end
  end

  def it_does_not_change(attribute)
    it "does not change #{attribute}" do
      expect {
        subject.send("#{event}!", *event_args)
        subject.reload
      }.to_not change(subject, attribute.to_sym)
    end
  end
end
