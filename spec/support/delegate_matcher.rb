# RSpec matcher to spec delegations.
#
# stolen from: https://gist.github.com/807456
# changed to use mocha instead of rspec-mocks
#
# Usage:
#
#     describe Post do
#       it { should delegate(:name).to(:author).with_prefix } # post.author_name
#       it { should delegate(:month).to(:created_at) }
#       it { should delegate(:year).to(:created_at) }
#     end

RSpec::Matchers.define :delegate do |method|
  match do |delegator|
    @method = @prefix ? :"#{@to}_#{method}" : method
    @delegator = delegator
    begin
      @delegator.send(@to)
    rescue NoMethodError
      raise "#{@delegator} does not respond to #{@to}!"
    end
    @delegator.stubs(@to).returns stub('receiver')
    @delegator.send(@to).stubs(method).returns :called
    @delegator.send(@method) == :called
  end

  description do
    "delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  failure_message_for_should do |text|
    "expected #{@delegator} to delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  failure_message_for_should_not do |text|
    "expected #{@delegator} not to delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  chain(:to) do |receiver|
    # reset @prefix
    @prefix = nil

    @to = receiver
  end
  chain(:with_prefix) { @prefix = true }

end
