require_relative "web"
require_relative "interactions"

Thread.abort_on_exception = true

Thread.new do
  begin
    TwitterTIL::MonitorTwitterFeed.call
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run TwitterTIL::Web
