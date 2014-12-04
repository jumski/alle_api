
module WaitWithRetry

  def wait_with_retry(opts)
    raise "Please provide message with :for key!" unless opts.key?(:for)
    raise "Please provide wait time with :seconds key!" unless opts.key?(:seconds)
    raise "Please provide retry number with :times key!" unless opts.key?(:times)
    raise "Please provide a block!" unless block_given?

    message, seconds, iterations = opts.values_at(:for, :seconds, :times)
    sleep_duration = 0.1
    number_of_dots = (seconds/0.2).to_i
    retries_count = 0

    begin
      print "[retried #{retries_count} of #{iterations}] Wait #{seconds} seconds for #{message}"
      number_of_dots.times { sleep sleep_duration; print '.' }
      puts

      yield
    rescue
      raise "Waited for #{message}, but it failed!" if retries_count >= iterations

      retries_count+= 1
      retry
    end
  end

end

RSpec.configure do |config|
  config.include WaitWithRetry
end


